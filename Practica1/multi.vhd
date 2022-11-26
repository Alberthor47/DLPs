----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:25:32 09/12/2022 
-- Design Name: 
-- Module Name:    multi - Behavioral 
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

entity multi is
		Port(
			SAL_250us: in std_logic;
			D: out std_logic_vector (3 downto 0)
		);
end multi;

architecture Behavioral of multi is

	--Declaración de señales de la asignación de U-D-C
	signal P: std_logic_vector (9 DOWNTO 0); -- asigna UNI,DEC,CEN
	signal UNI,DEC,CEN: std_logic_vector (3 DOWNTO 0); -- unidades, decenas, centenas

	-- Declaración de señales de la multiplexación y asignación de U-D-C-UM al display
	signal SEL: std_logic_vector (1 downto 0):="00"; -- selector de barrido
	
begin

	PROCESS(SAL_250us, sel, UNI, DEC,CEN)
	BEGIN
		IF SAL_250us'EVENT and SAL_250us='1' THEN SEL <= SEL+'1';
			CASE(SEL) IS
				when "00" => AN <="0111"; D <= UNI; -- UNIDADES
				when "01" => AN <="1011"; D <= DEC; -- DECENAS
				when "10" => AN <="1101"; D <= CEN; -- CENTENAS
				when OTHERS=>AN <="1111"; -- OFF
			END CASE;
		end if;
	END PROCESS; -- fin del proceso Multiplexor

end Behavioral;

