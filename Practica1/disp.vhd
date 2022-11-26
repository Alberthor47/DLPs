----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:29:50 09/12/2022 
-- Design Name: 
-- Module Name:    disp - Behavioral 
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

entity disp is
	Port(
			D: out std_logic_vector (3 downto 0)
		);
end disp;

architecture Behavioral of disp is

begin

	PROCESS(D)
	Begin
		case(D) is -- abcdefgP
			WHEN "0000" => DISPLAY <= "00000011"; --0
			WHEN "0001" => DISPLAY <= "10011111"; --1
			WHEN "0010" => DISPLAY <= "00100101"; --2
			WHEN "0011" => DISPLAY <= "00001101"; --3
			WHEN "0100" => DISPLAY <= "10011001"; --4
			WHEN "0101" => DISPLAY <= "01001001"; --5
			WHEN "0110" => DISPLAY <= "01000001"; --6
			WHEN "0111" => DISPLAY <= "00011111"; --7
			WHEN "1000" => DISPLAY <= "00000001"; --8
			WHEN "1001" => DISPLAY <= "00001001"; --9
			WHEN OTHERS => DISPLAY <= "11111111"; --apagado
		END CASE;
	END PROCESS; -- fin del proceso Display

end Behavioral;

