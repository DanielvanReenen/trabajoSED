----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.12.2024 13:10:32
-- Design Name: 
-- Module Name: decoder_trabajo - dataflow
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY decoder_trabajo IS
  PORT (
    state : IN std_logic_vector(1 DOWNTO 0);
    led : OUT std_logic_vector(20 DOWNTO 0)
  );
END ENTITY decoder_trabajo;


ARCHITECTURE dataflow OF decoder_trabajo IS
  BEGIN
    WITH state SELECT
      led <= "001100001100000001000" WHEN "00",
             "111111100010001001000" WHEN "01",
             "000111110000010001000" WHEN "10",
             "000100000010000110000" WHEN others;
END ARCHITECTURE dataflow;
