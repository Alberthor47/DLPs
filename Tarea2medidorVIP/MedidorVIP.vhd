----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:27:58 11/21/2022 
-- Design Name: 
-- Module Name:    MedidorVIP - Behavioral 
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
use ieee.numeric_std.all;

entity MedidorVIP is
	port (
		led_test : out std_logic := '1'; -- To know if the program is on the board
		
		-- FPGA clock and buttons
		clk : in std_logic; -- 50MHz
		rst : in std_logic; -- reset
		
		-- LCD Display
		led_busy : out std_logic; -- LED showing activity in LCD
		lcd_e : out std_logic; -- E from LCD
		lcd_rs : out std_logic; -- RS from LCD
		lcd_rw : out std_logic; -- RW from LCD
		lcd_d : out std_logic_vector(7 downto 0); -- D ports from LCD
		
		-- V Meter
		test_sw : in std_logic_vector(7 downto 0)
	);
end MedidorVIP;

architecture Behavioral of MedidorVIP is

	-- Modules
	component lcd_controller is
		port(
			clk        : in std_logic; -- system clock
			reset_n    : in std_logic; -- active low reinitializes lcd
			lcd_enable : in std_logic; -- latches data into lcd controller
			lcd_bus    : in std_logic_vector(9 downto 0); --data and control signals
			busy       : out std_logic := '1'; --lcd controller busy/idle feedback
			rw, rs, e  : out std_logic; --read/write, setup/data, and enable for lcd
			lcd_data   : out std_logic_vector(7 downto 0) -- Pins to conect to LCD
		);
	end component lcd_controller;
	
	component data_logic is
		port(
			clk : in std_logic; -- system clock
			lcd_busy : in std_logic; -- lcd controller busy feedback
			lcd_enable : buffer std_logic; -- lcd controller enable feedback 
			lcd_bus : out std_logic_vector(9 downto 0); -- information to send to lcd controller
			led_busy : out std_logic -- LED showing activity in LCD;
			--reset : out std_logic
		);
	end component data_logic;
	
--	component v_meter is
--		port(
--			
--		);
--	end component v_meter;
	
	-- Signals
	signal lcd_enable_sig : std_logic;
	signal lcd_bus_sig : std_logic_vector(9 downto 0);
	signal busy_sig : std_logic;
	--signal rst_sig : std_logic;
	
begin
	
	C0: lcd_controller port map (
		clk => clk,
		reset_n => rst,
		lcd_enable => lcd_enable_sig,
		lcd_bus => lcd_bus_sig,
		busy => busy_sig,
		e => lcd_e,
		rs => lcd_rs,
		rw => lcd_rw,
		lcd_data => lcd_d
	);

	C1: data_logic port map (
		clk => clk,
		lcd_busy => busy_sig,
		lcd_enable => lcd_enable_sig,
		lcd_bus => lcd_bus_sig,
		led_busy => led_busy
		--reset => rst_sig
	);
	
end Behavioral;

