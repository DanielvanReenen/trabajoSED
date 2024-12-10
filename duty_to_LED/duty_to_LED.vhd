----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.12.2024 19:04:05
-- Design Name: 
-- Module Name: duty_to_LED - Behavioral
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

ENTITY duty_to_LED IS
  PORT (
    duty : IN std_logic_vector(3 DOWNTO 0);
    led : OUT std_logic_vector(15 DOWNTO 0) 
  );
END ENTITY duty_to_LED;


ARCHITECTURE dataflow OF duty_to_LED IS
  BEGIN
    WITH duty SELECT
      led <= "0000000000000001" WHEN "0001",
             "0000000000000011" WHEN "0010",
             "0000000000000111" WHEN "0011",
             "0000000000001111" WHEN "0100",
             "0000000000011111" WHEN "0101",
             "0000000000111111" WHEN "0110",
             "0000000001111111" WHEN "0111",
             "0000000011111111" WHEN "1000",
             "0000000111111111" WHEN "1001",
             "0000001111111111" WHEN "1010",
             "0000011111111111" WHEN "1011",
             "0000111111111111" WHEN "1100",
             "0001111111111111" WHEN "1101",
             "0011111111111111" WHEN "1110",
             "0111111111111111" WHEN "1111",
             "0000000000000000" WHEN others;
END ARCHITECTURE dataflow;

