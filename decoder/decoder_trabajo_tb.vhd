----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.11.2024 21:38:51
-- Design Name: 
-- Module Name: P2_tb - Behavioral
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

ENTITY decoder_trabajo_tb IS
END ENTITY decoder_trabajo_tb;

ARCHITECTURE behavior OF decoder_trabajo_tb IS

  COMPONENT decoder_trabajo
    PORT(
      state : IN std_logic_vector(1 DOWNTO 0);
      led : OUT std_logic_vector(20 DOWNTO 0)
    );
  END COMPONENT;

  SIGNAL state : std_logic_vector(1 DOWNTO 0) := "00";
  SIGNAL led : std_logic_vector(20 DOWNTO 0);

BEGIN

  uut: decoder_trabajo PORT MAP (
    state => state,
    led => led
  );

  stim_proc: PROCESS
  BEGIN
    -- Caso "00"
    state <= "00";
    WAIT FOR 100 ns;
    
    -- Caso "01"
    state <= "01";
    WAIT FOR 100 ns;

    -- Caso "10"
    state <= "10";
    WAIT FOR 100 ns;

    -- Caso "11"
    state <= "11";
    WAIT FOR 100 ns;
    
     ASSERT false
            REPORT "Simulacin finalizada. Test superado."
            SEVERITY FAILURE;
            
END PROCESS;
END ARCHITECTURE behavior;