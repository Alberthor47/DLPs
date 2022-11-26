`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:06:16 10/10/2022 
// Design Name: 
// Module Name:    P4_BTH 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module P4_BTH(
	input clk, //50MHz
	input reset, //reset
	input rx, //entrada de datos del modulo bluetooth (a DO)
	output reg[7:0] leds=8'b00000000, //salida a leds
	output reg[7:0] dsply=8'b11111110, //salida a display 7seg
	output reg[3:0] anode=8'b1110, //salida a ánodos
	output reg[1:0] ste=2'b00, //indicador de estado actual
	output reg[2:0] bulb=3'b000 //actuadores de bombillos 12V
); //fin del módulo receptor bth

	// Estados de la FSM
	reg [1:0] presentstate, nextstate;
	parameter EDO_1 = 2'b00;
	parameter EDO_2 = 2'b10;
	
	// señales
	reg control=0; //indica cuando ocurre el bit de start
	reg done=0; // bandera que indica que termino de recibir los datos
	reg[8:0]tmp=9'b000000000; //registro que recibe los datos enviados
	
	// Contadores para los retardos
	reg[3:0]i=4'b0000; //contador de los bits recibidos
	reg[9:0]c=10'b1111111111; //contador de retardos
	reg delay=0; //algoritmo para los retardos
	reg[1:0]c2=2'b11;
	reg capture=0;
	
// Proceso de retardo al triple de la frecuencia
//868*20ns=17.36us
//17.36us*3=58.08us
//58.08us*2=104.16us=1/9600baudios o bits/seg
always@(posedge clk)
begin : RETARDO
	if(c<868) begin
		c=c+1;
	end else begin
		c=0;
		delay=~delay;
	end
end

// Proceso para el contador C2 para la captura
always@(posedge delay)
begin : CAPTURA1
	if (c2>1) begin
		c2=0;
	end else begin
		c2=c2+1;
	end
end

// Proceso para capturar en el bit de en medio (capture)
always@(c2)
begin : CAPTURA2
	if (c2==1) begin
		capture=1;
	end else begin
		capture=0;
	end
end

// Actualizacion de FSM
always@(posedge capture, posedge reset)
begin : ACTIALIZACION_FSM
	if (reset) begin 
		presentstate <= EDO_1;
	end else begin
		presentstate <= nextstate;
	end
end

//FSM
always@(*)
begin : FSM
	case(presentstate)
		EDO_1: 
		begin
			//AQUI cambia valor de ste
			ste<=2'b10;
			if(rx==1 && done==0) begin
				control=0;
				nextstate= EDO_1;
			end else if(rx==0 && done==0) begin
				control=1;
				nextstate= EDO_2;
			end else begin
				control=0;
				nextstate= EDO_1;
			end
		end		
		EDO_2: 
		begin	
			//AQUI cambia valor de ste
			ste<=2'b01;
			if(done==0) begin
				control=1;
				nextstate= EDO_2;
			end else begin
				control=0;
				nextstate= EDO_1;
			end
		end
		default:	nextstate= EDO_1;
	endcase
end

// Proceso de recepción de datos
always@(posedge capture)
begin : RECEPCION
	if (control==1 && done==0) begin
		tmp <= {rx,tmp[8:1]};
	end
end

// Proceso que cuenta los bits que llegan (9 bits)
always@(posedge capture)
begin : CONTADOR
	if (reset) begin
		// abcdefgp
		leds<=8'b00000000;
		anode<=4'b1110;
	end else if (control)
		if(i>=9) begin
			i=0;
			done=1;
			leds<=tmp[8:1];
			
			case (tmp[8:1]) // abcdefgp
				8'h30 : dsply <= 8'b00000011; // 0
				8'h31 : 
				begin
					bulb <= 3'b100;
					dsply <= 8'b10011111; // 1
				end
				8'h32 : 
				begin 
					bulb <= 3'b010;
					dsply <= 8'b00100101; // 2
				end
				8'h33 :
				begin
					bulb <= 3'b001;
					dsply <= 8'b00001101; // 3
				end 
				8'h34 : dsply <= 8'b10011001; // 4
				8'h35 : dsply <= 8'b01001001; // 5
				8'h36 : dsply <= 8'b01000001; // 6
				8'h37 : dsply <= 8'b00011111; // 7
				8'h38 : dsply <= 8'b00000000; // 8
				8'h39 : dsply <= 8'b00001001; // 9
				8'h41 : dsply <= 8'b00010001; // A
				8'h42 : dsply <= 8'b11000001; // B
				8'h43 : dsply <= 8'b01100011; // C
				8'h44 : dsply <= 8'b10000101; // D
				8'h45 : dsply <= 8'b01100001; // E
				8'h46 : dsply <= 8'b01110001; // F
				8'h47 : dsply <= 8'b01000000; // G = 6.
				8'h48 : dsply <= 8'b10010001; // H
				8'h49 : dsply <= 8'b11011111; // I
				8'h2B : dsply <= 8'b10011101; // +
				8'h2F : dsply <= 8'b10110101; // /
				default : dsply <= 8'b11101111; // _
			endcase
		end else begin
			i=i+1;
			done=0;
		end else begin
			done=0;
		end
end

endmodule