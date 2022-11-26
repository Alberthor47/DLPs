----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:22:11 09/06/2022 
-- Design Name: 
-- Module Name:    p6_pmodals - Behavioral 
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

entity p6_pmodals is

	generic(
		N : integer := 8 -- number of bit to serialize
	);
	
	port (
		--FPGA clock and button
		clk : in std_logic; -- 50MHz
		rst : in std_logic; -- reset
		--PmodALS
		CS : out std_logic; -- Pmod chip selec
		SDO : in std_logic; -- Pmod Serial Data Output
		SCK : out std_logic; -- Pmod Serial Clock
		-- led output
		data : out std_logic_vector(N-1 downto 0):=x"00"; -- received data
		-- Display "abcdefgP"
		DISPLAY: out STD_LOGIC_VECTOR(7 DOWNTO 0); -- segmentos del display
		AN: out STD_LOGIC_VECTOR(3 DOWNTO 0):="0111" -- ánodos del display
	);

end p6_pmodals;

architecture Behavioral of p6_pmodals is

	--Declaración de modulos para top level

	component div is
		port(
			rst : in std_logic;
			clk : in std_logic;
			SDO : in std_logic;
			CS : out std_logic;
			SCK : out std_logic;
			data: out  std_logic_vector(N-1 downto 0):=x"00";
			tempo: inout std_logic_vector(0 to 15):=x"0000"
		);
	end component;
	
	component bin2bcd is
		port(
			tempo: inout std_logic_vector(0 to 15):=x"0000"
		);
	end component
	
	component anode_division is
		Port(
			clk: in std_logic;
			contadors: out integer range 1 to 6250:=1;
			SAL_250us: out std_logic
		);
	end component
	
	component mult is 
		Port(
			SAL_250us: in std_logic;
			D: out std_logic_vector (3 downto 0)
		);
	end component
	
	component disp is 
		Port(
			D: out std_logic_vector (3 downto 0)
		);
	end component
	
	--Declaración de señales
	signal tempo : std_logic_vector(0 to 15):=x"0000"; -- save data
	signal D: std_logic_vector (3 downto 0); -- sirve para almacenar los valores del display
	signal contadors: integer range 1 to 6250:=1; -- pulso1 de 0.25ms (pro. divisor ánodos)
	signal SAL_250us: std_logic; --

begin

---------------------- MAIN -----------------------------------------------

	C0: div port map (rst=>rst,clk=>clk,SDO=>SDO,CS=>CS,SCK=>SCK,tempo=>tempo);

----------- CONVERTIR DE BIN A BCD ----------------------------------------

	C1: bin2bcd port map (tempo=>tempo);

------------------- DIVISOR ÁNODOS ----------------------------------------

	C2: anode_division port map (clk=>clk,contadors=>contadors,SAL_250us=>SAL_250us);

-------------------- MULTIPLEXOR ------------------------------------------
	
	C3: multi port map (SAL_250us=>SAL_250us,D=>D);

-------------------- DISPLAY ----------------------------------------------

	C4: disp port map (D=>D);

end Behavioral;

