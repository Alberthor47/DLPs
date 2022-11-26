----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:13:11 09/12/2022 
-- Design Name: 
-- Module Name:    anode_division - Behavioral 
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

entity anode_division is
	Port(
		clk: in std_logic;
		contadors: out integer range 1 to 6250:=1;
		SAL_250us: out std_logic
	);
end anode_division;

architecture Behavioral of anode_division is

begin

	process (CLK) begin
		if rising_edge(CLK) then
			if (contadors = 6250) then --cuenta 0.125ms (50MHz=6250)
				-- if (contadors = 12500) then --cuenta 0.125ms (100MHz=12500)
				SAL_250us <= NOT(SAL_250us); --genera un barrido de 0.25ms
				contadors <= 1;
			else
				contadors <= contadors+1;
			end if;
		end if;
	end process; -- fin del proceso Divisor Ánodos

end Behavioral;

