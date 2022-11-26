----------------------------------------------------------------------------------
-- Company: 	DLP's COMPANY
-- Engineer:   	Alberto Camarena Rodriguez
-- Create Date:    21:13:50 10/24/2022 
-- Module Name:    Punto5 - Behavioral 
-- Project Name:    Control de servomotor 180 grados con encoder rotatorio
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Punto5 is

	Generic ( 
		msb : integer := 5; --número de bits del contador
	   min : integer := 50000; --valor mínimo del contador para el tiempo en alto
	   max : integer := 100000; --valor máximo del contador para el tiempo en alto
	   inc : integer := 1388; -- incremento para el tiempo en alto
	   N : integer := 35 --divisor
	); 

	Port (
		clk : in STD_LOGIC; --reloj de 50MHz de la amiba2
		reset: in STD_LOGIC; --reset asíncrono en alto
		A,B : in STD_LOGIC; --señales A y B del encoder
		contador : out STD_LOGIC_VECTOR (msb-1 downto 0); --salida del contador de 5 bits cuando msb=5
		display : out STD_LOGIC_VECTOR (7 downto 0):="00000001"; --salida a display de 7 segmentos + P
		AN : out STD_LOGIC_VECTOR (0 to 3); --salida a los ánodos
		servomotor,servoLED : out STD_LOGIC --salidas de pwm para el servomotor y un led testigo
	);
	
end Punto5;

architecture Behavioral of Punto5 is
	--se utiliza una FSM moore para leer el encoder
	type edos is (EA, EB, EC, ED);
	signal EP: edos:=EA;
	
	--declaración de señales
	signal clkdiv: std_logic_vector(N downto 0); --señal para el divisor
	signal AB: std_logic_vector (1 to 2); --señal que une las señales del encoder
	signal cntPWM: integer range 1 to 500000 := 1; --contador de 10ms @ clk=50MHz o T=20ns
	signal cnt: integer range 0 to 35:= 0; --contador de 0 a 35
	signal servo: std_logic; --señal de PWM para las salidas servos
	signal high: integer range min to max := min; --duración del tiempo en alto de la señal PWM
begin

	AB <= A & B; --unión (concatenación) de las señales del encoder
	AN <= "1110"; --activación del ánodo del display uno
	
	divisor: --proceso del divisor
		process(clk,reset)
		begin
			if reset = '1' then clkdiv <= (others => '0');
			elsif rising_edge(clk) then clkdiv <= clkdiv + 1;
			end if;
		end process divisor;
		
	FSM: --proceso que detecta los giros del encoder y genera la variable cnt
		process (clkdiv(N),reset,cnt)
		begin
			--if resetB = '1' then EP <= EA; cnt<=0;
			--elsif rising_edge(clkdiv(N)) then
			if rising_edge(clkdiv(N)) then
				case EP is
					when EA =>
						if AB = "00" then EP <= EA; cnt<=cnt; --hold
						elsif AB = "10" then EP <= EB; --cw
							if cnt = 35 then cnt <= 35;
							elsif cnt < 35 then cnt <= cnt + 1;
							else cnt <= cnt;
							end if;
						elsif AB = "01" then EP <= ED; --ccw
							if cnt = 0 then cnt <= 0;
							elsif cnt > 0 then cnt <= cnt - 1;
							else cnt <= cnt;
							end if;
						end if;
					when EB => cnt <= cnt; --hold
						if AB = "10" then EP <= EB;
						elsif AB = "11" then EP <= EC;
						elsif AB = "00" then EP <= EA;
						end if;
					when EC =>
						if AB = "11" then EP <= EC; cnt<=cnt; --hold
						elsif AB = "01" then EP <= ED; --cw
							if cnt = 35 then cnt <= 35;
							elsif cnt < 35 then cnt <= cnt + 1;
							else cnt <= cnt;
							end if;
						elsif AB = "10" then EP <= EB; --ccw
							if cnt = 0 then cnt <= 0;
							elsif cnt > 0 then cnt <= cnt - 1;
							else cnt <= cnt;
							end if;
						end if;
					when ED => cnt <= cnt; --hold
						if AB = "01" then EP <= ED;
						elsif AB = "00" then EP <= EA;
						elsif AB = "11" then EP <= EC;
						end if;
					when others => null;
				end case;
			end if;
		end process FSM;
		
	Pulso: --proceso que genera el pulso de salida e indica en el display un valor
		process(clk,servo)
		begin
			if rising_edge(clk) then cntPWM <= cntPWM + 1; --contador de 1 a 500,000
				high <= min + ((cnt)*(inc));
				if cntPWM <= high then servo <= '1';
				else servo <= '0';
				end if;
			else null;
			end if;
		end process Pulso;
		
	Disp:
		process(clk,cnt)
		begin
			if rising_edge(clk) then 
				case cnt is --orden: abcdefgP-ánodo común, contador = salida a leds
					when 0 => display <= "00000011"; AN <= "1110"; display <= "00000011"; AN <= "1110"; contador <= '0' & x"0"; -- 0 al display
					when 1 => display <= "10011111"; contador <= '0' & x"1"; -- 1 al display
					when 2 => display <= "00100101"; contador <= '0' & x"2"; -- 2 al display
					when 3 => display <= "00001101"; contador <= '0' & x"3"; -- 3 al display
					when 4 => display <= "10011001"; contador <= '0' & x"4"; -- 4 al display
					when 5 => display <= "01001001"; contador <= '0' & x"5"; -- 5 al display
					when 6 => display <= "01000001"; contador <= '0' & x"6"; -- 6 al display
					when 7 => display <= "00011111"; contador <= '0' & x"7"; -- 7 al display
					when 8 => display <= "00000001"; contador <= '0' & x"8"; -- 8 al display
					when 9 => display <= "00001001"; contador <= '0' & x"9"; -- 9 al display
					when 10 => display <= "00010001"; contador <= '0' & x"A"; -- A al display
					when 11 => display <= "11000001"; contador <= '0' & x"B"; -- B al display
					when 12 => display <= "01100011"; contador <= '0' & x"C"; -- C al display
					when 13 => display <= "10000101"; contador <= '0' & x"D"; -- D al display
					when 14 => display <= "01100001"; contador <= '0' & x"E"; -- E al display
					when 15 => display <= "01110001"; contador <= '0' & x"F"; -- F al display
					when 16 => display <= "00000010"; contador <= '1' & x"0"; -- 0. al display
					when 17 => display <= "10011110"; contador <= '1' & x"1"; -- 1. al display
					when 18 => display <= "00100100"; contador <= '1' & x"2"; -- 2. al display
					when 19 => display <= "00001100"; contador <= '1' & x"3"; -- 3. al display
					when 20 => display <= "10011000"; contador <= '1' & x"4"; -- 4. al display
					when 21 => display <= "01001000"; contador <= '1' & x"5"; -- 5. al display
					when 22 => display <= "01000000"; contador <= '1' & x"6"; -- 6. al display
					when 23 => display <= "00011110"; contador <= '1' & x"7"; -- 7. al display
					when 24 => display <= "00000000"; contador <= '1' & x"8"; -- 8. al display
					when 25 => display <= "00001000"; contador <= '1' & x"9"; -- 9. al display
					when 26 => display <= "00010000"; contador <= '1' & x"A"; -- A. al display
					when 27 => display <= "11000000"; contador <= '1' & x"B"; -- B. al display
					when 28 => display <= "01100010"; contador <= '1' & x"C"; -- C. al display
					when 29 => display <= "10000100"; contador <= '1' & x"D"; -- D. al display
					when 30 => display <= "01100000"; contador <= '1' & x"E"; -- E. al display
					when 31 => display <= "01110000"; contador <= '1' & x"F"; -- F. al display
					when others => display <= "11111101"; contador <= '0' & x"0";
				end case;
			servomotor <= servo; --salida de la señal PWM hacia el servomotor
			servoLED <= servo; --salida de la señal PWM del led testigo
			end if;
		end process Disp;
			
end Behavioral;

