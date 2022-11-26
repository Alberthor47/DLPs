----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:46:23 09/08/2022 
-- Design Name: 
-- Module Name:    div - Behavioral 
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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity div is
	generic(
		MAX: integer := 333_333 -- number of us to sample
	);

	Port(
		rst : in std_logic;
		clk : in std_logic;
		SDO : in std_logic;
		CS : out std_logic;
		SCK : out std_logic;
		data: out  std_logic_vector(N-1 downto 0):=x"00";
		tempo: inout std_logic_vector(0 to 15):=x"0000"
	);
end div;

architecture Behavioral of div is

	--Declaración de señales para SPI
	signal clkdiv : std_logic; -- divisor
	signal counter : integer range 0 to MAX:=0; -- control counter
	signal cnt : std_logic_vector(4 downto 0); -- divisor counter

begin

	div : process(rst,clk,clkdiv,counter)
	begin
		-- divisor 1MHz (1us)
		if(rst='1') then clkdiv <= '0';
		elsif(rising_edge(clk)) then
		if cnt = "11000" then cnt <= "00000"; -- 0 a 24

		clkdiv <= not clkdiv; -- 0.5us alto, 0.5us bajo

		else cnt <= cnt + '1';
		end if;
		end if;
		SCK <= clkdiv;
	end process div;
	
	
	receive : process(clkdiv,counter,tempo,SDO,rst)
	begin
		if(rst='1') then tempo <= (others => '0');
		elsif(rising_edge(clkdiv)) then
			case counter is
				when 0 => CS <= '1';
				when 1 => CS <= '1';
				when 2 => CS <= '0';
				when 3 => tempo(0) <= SDO; --0
				when 4 => tempo(1) <= SDO; --0
				when 5 => tempo(2) <= SDO; --0
				when 6 => tempo(3) <= SDO; --DB7
				when 7 => tempo(4) <= SDO; --DB6
				when 8 => tempo(5) <= SDO; --DB5
				when 9 => tempo(6) <= SDO; --DB4
				when 10 => tempo(7) <= SDO; --DB3
				when 11 => tempo(8) <= SDO; --DB2
				when 12 => tempo(9) <= SDO; --DB1
				when 13 => tempo(10) <= SDO; --DB0
				when 14 => tempo(11) <= SDO; --0
				when 15 => tempo(12) <= SDO; --0
				when 16 => tempo(13) <= SDO; --0
				when 17 => tempo(14) <= SDO; --0
				when 18 => tempo(15) <= SDO; --tri state
				when 19 => CS <= '1'; --
				when others => CS <= '1'; --
			end case;
		end if;
		data <= tempo (3 to 10);
	end process receive;

	cnter : process(rst,counter,clkdiv)
	begin
		-- divisor 1MHz (1us)
		if(rst='1' or counter = MAX) then counter <= 0;
		elsif(rising_edge(clkdiv)) then counter <= counter + 1 ;
		end if;
	end process cnter;

end Behavioral;

