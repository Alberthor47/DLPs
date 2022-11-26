----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:47:30 10/10/2022 
-- Design Name: 
-- Module Name:    motorBi - Behavioral 
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
use IEEE.std_logic_1164.all;
entity Motorbipolar is
port (clk, dir, stop, vel: in std_logic;
mot: out std_logic_vector (3 downto 0)
);
end Motorbipolar;
architecture a_Motorbi of Motorbipolar is
-------Señales para el divisor de frecuencia (100 y 666Hz)
constant escala_666hz: integer := 75_000;
constant escala_100hz: integer := 500_000;
signal conta0: integer range 0 to escala_100hz:=0;
signal conta1: integer range 0 to escala_666hz:=0;
-- señales para la generacion de banderas para controlar la velocidad
--el cambio que hay entre cada estado de la maquina
signal bandera: std_logic := '0';
signal bandera1: std_logic := '0';
signal auxban: std_logic;
-- declaración de los estados
type maquina is (E1,E2,E3,E4);
signal edpre,edfu: maquina := E1;
begin
--Procesos que generan señales de 100 y 666 hz respectivamente
-- para controlar el velocidad del motor, siendo el valor de 666hz
--la maxima frecuencia a la cual el motor respondio correctamente
--si se aumentaba la frecuencia el motor no giraba correctamente
process(clk)
begin
if rising_edge(clk) then
conta0 <= conta0+1;
if conta0 = escala_100hz then
conta0 <=0;
bandera <= '1';
else
bandera <='0';
end if;
end if;
end process;
process(clk)
begin
if rising_edge(clk) then
conta1 <= conta1+1;
if conta1 = escala_666hz then
conta1 <=0;
bandera1 <= '1';
else
bandera1 <='0';
end if;
end if;
end process;
--Seleccion de la bandera que hara el cambio de estados y por
-- consecuencia controlara la velocidad del motor
process(vel,bandera,bandera1)
begin
if vel = '0' then
auxban <= bandera;
else
auxban <= bandera1;
end if;
end process;
--Maquina de estados para el cambio de polarizacion de las bobinas del motor
--Se pregunta antes de entrar a la maquina de estados si stop esta
--en 1, si no lo esta no se ejecuta la maquina y el motor se mantendran apagado
process(edpre,auxban,stop,dir)
begin
if stop = '1' then
case edpre is
when E1 =>
if auxban = '0' then
mot <= "1010";
edfu <= E1;
else
if dir = '0' then
mot <= "0110";
edfu <= E4;
else
mot <= "1001";
edfu <= E2;
end if;
end if;
when E2 =>
if auxban = '0' then
mot <= "1001";
edfu <= E2;
else
if dir = '0' then
mot <= "1010";
edfu <= E1;
else
mot <= "0101";
edfu <= E3;
end if;
end if;
when E3 =>
if auxban = '0' then
mot <= "0101";
edfu <= E3;
else
if dir = '0' then
mot <= "1001";
edfu <= E2;
else
mot <= "0110";
edfu <= E4;
end if;
end if;
when E4 =>
if auxban = '0' then
mot <= "0110";
edfu <= E4;
else
if dir = '0' then
mot <= "0101";
edfu <= E3;
else
mot <= "1010";
edfu <= E1;
end if;
end if;
when others =>
mot <="0000";
edfu <= E1;
end case;
else
mot <= "0000";
end if;
end process;
process(clk)
begin
if rising_edge(clk) then
edpre <= edfu;
end if;
end process;
end a_Motorbi;

