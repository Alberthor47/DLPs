----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:26:43 09/08/2022 
-- Design Name: 
-- Module Name:    bin2bcd - Behavioral 
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

entity bin2bcd is

	Port(
		tempo: inout std_logic_vector(0 to 15):=x"0000"
	);

end bin2bcd;

architecture Behavioral of bin2bcd is

begin

-- utilizando shift and add
	PROCESS(tempo(3 to 10))
	VARIABLE C_D_U:STD_LOGIC_VECTOR(17 DOWNTO 0);
	--18 bits para separar las Centenas-Decenas-Unidades
		BEGIN
		--ciclo de inicialización
		FOR I IN 0 TO 17 LOOP --
		C_D_U(I):='0'; -- se inicializa con 0
		END LOOP;
		C_D_U(7 DOWNTO 0):=tempo (3 to 10); --tempo de 8 bits
		--ciclo de asignación C-D-U
		FOR I IN 0 TO 7 LOOP
		-- los siguientes condicionantes comparan (>=5) y suman 3
		IF C_D_U(11 DOWNTO 8) > 4 THEN -- U
		C_D_U(11 DOWNTO 8):= C_D_U(11 DOWNTO 8)+3;
		END IF;
		IF C_D_U(15 DOWNTO 12) > 4 THEN -- D
		C_D_U(15 DOWNTO 12):= C_D_U(15 DOWNTO 12)+3;
		END IF;
		IF C_D_U(17 DOWNTO 16) > 4 THEN -- C
		C_D_U(17 DOWNTO 16):= C_D_U(17 DOWNTO 16)+3;
		END IF;
		-- realiza el corrimiento
		C_D_U(17 DOWNTO 1):= C_D_U(16 DOWNTO 0);
		END LOOP;
		P<=C_D_U(17 DOWNTO 8); -- guarda en P y en seguida se separan UM-C-D-U
	END PROCESS;
	--UNIDADES
	UNI<=P(3 DOWNTO 0);
	--DECENAS
	DEC<=P(7 DOWNTO 4);
	--CENTENAS
	CEN<="00"&P(9 DOWNTO 8);

end Behavioral;

