`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:17:49 09/05/2022 
// Design Name: 
// Module Name:    p6_pmodenc 
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
module p6_pmodenc(
    clk,
    JA,
    an,
    seg,
    Led,
	 AuxLed,
	 Sw
    );
	 // ===========================================================================
	 // 										Port Declarations
	 // ===========================================================================
    input clk;
	 input Sw;
    input [7:4] JA;
    output [3:0] an;
    output [6:0] seg;
    output AuxLed;
	 output [1:0] Led;

	 // ===========================================================================
	 // 							  Parameters, Regsiters, and Wires
	 // ===========================================================================
	 wire [3:0] an;
	 wire [6:0] seg;
	 wire [1:0] Led;
	 wire [4:0] EncO;
	 
	 // ===========================================================================
	 // 										Implementation
	 // ===========================================================================
	 LedController C3_LedController (
					.clk(clk),
					.LED(AuxLed),
					.SW(Sw)
	 );

	 Debouncer C0_Debouncer (
				  .clk(clk),
				  .Ain(JA[4]),
				  .Bin(JA[5]),
				  .Aout(AO),
				  .Bout(BO)
	 );
	 
 	 Encoder C1_Encoder (
				  .clk(clk),
				  .A(AO),
				  .B(BO),
				  .BTN(JA[6]),
				  .EncOut(EncO),
				  .LED(Led)
	 );

 	 DisplayController C2_DisplayController (
				  .clk(clk),
				  .SWT(JA[7]),
				  .DispVal(EncO),
				  .anode(an),
				  .segOut(seg)
	 );

endmodule
