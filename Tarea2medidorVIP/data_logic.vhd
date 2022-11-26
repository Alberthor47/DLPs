----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:15:46 11/21/2022 
-- Design Name: 
-- Module Name:    data_logic - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity data_logic is
	port(
		clk : in std_logic;
--		lecture: in std_logic_vector(15 downto 0);
		lcd_busy : in std_logic; 
		lcd_enable : buffer std_logic;
		lcd_bus : out std_logic_vector(9 downto 0);
		led_busy : out std_logic
		--reset : out std_logic
	);
end data_logic;

architecture logic of data_logic is

	-- ASCII Characters to print
	constant RS : std_logic := '1';
	constant RW : std_logic := '0';
	constant space : std_logic_vector(9 downto 0) := RS & RW & "00100000";
	constant V : std_logic_vector(9 downto 0) := RS & RW & "01010110";
	constant I : std_logic_vector(9 downto 0) := RS & RW & "01001001";
	constant P : std_logic_vector(9 downto 0) := RS & RW & "01010000";
	constant F : std_logic_vector(9 downto 0) := RS & RW & "01000110";
	constant a0 : std_logic_vector(9 downto 0) := RS & RW & "00110000";
	constant a1 : std_logic_vector(9 downto 0) := RS & RW & "00110001";
	constant a2 : std_logic_vector(9 downto 0) := RS & RW & "00110010";
	constant a3 : std_logic_vector(9 downto 0) := RS & RW & "00110011";
	constant a4 : std_logic_vector(9 downto 0) := RS & RW & "00110100";
	constant a5 : std_logic_vector(9 downto 0) := RS & RW & "00110101";
	constant a6 : std_logic_vector(9 downto 0) := RS & RW & "00110110";
	constant a7 : std_logic_vector(9 downto 0) := RS & RW & "00110111";
	constant a8 : std_logic_vector(9 downto 0) := RS & RW & "00111000";
	constant a9 : std_logic_vector(9 downto 0) := RS & RW & "00111001";
	constant dot : std_logic_vector(9 downto 0) := RS & RW & "00101110";
	constant colon : std_logic_vector(9 downto 0) := RS & RW & "00111010";
	constant br : std_logic_vector(9 downto 0) := "0011000000";
	
begin
	process(clk)
		variable char : integer range 0 to 32 := 0;
	begin
		if (clk'event and clk = '1') then
			led_busy <= lcd_busy;
			if (lcd_busy = '0' and lcd_enable = '0') then
				lcd_enable <= '1';
				if (char < 32) then
					char := char + 1;
				end if;
				case char is
					when 1 => lcd_bus <= V;
					when 2 => lcd_bus <= colon;
					when 3 => lcd_bus <= a0;
					when 4 => lcd_bus <= a0;
					when 5 => lcd_bus <= dot;
					when 6 => lcd_bus <= a1;
					when 7 => lcd_bus <= space;
					when 8 => lcd_bus <= I;
					when 9 => lcd_bus <= colon;
					when 10 => lcd_bus <= a0;
					when 11 => lcd_bus <= dot;
					when 12 => lcd_bus <= a0;
					when 13 => lcd_bus <= a0;
					when 14 => lcd_bus <= a1;
					when 15 => lcd_bus <= space;
					when 16 => lcd_bus <= br;
					when 17 => lcd_bus <= P;
					when 18 => lcd_bus <= colon;
					when 19 => lcd_bus <= a0;
					when 20 => lcd_bus <= a0;
					when 21 => lcd_bus <= dot;
					when 22 => lcd_bus <= a0;
					when 23 => lcd_bus <= a0;
					when 24 => lcd_bus <= a1;
					when 25 => lcd_bus <= space;
					when 26 => lcd_bus <= F;
					when 27 => lcd_bus <= colon;
					when 28 => lcd_bus <= a0;
					when 29 => lcd_bus <= a5;
					when 30 => lcd_bus <= a0;
					when 31 => lcd_bus <= space;
					when others => lcd_enable <= '0';
				end case;
			else
				lcd_enable <= '0';
			end if;
		end if;
	end process;
	
	--reset <= '1';
end logic;

