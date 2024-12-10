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
-- No hay puertos en el testbench
END ENTITY decoder_trabajo_tb;

ARCHITECTURE behavior OF decoder_trabajo_tb IS

  -- Component Declaration for the Unit Under Test (UUT)
  COMPONENT decoder_trabajo
    PORT(
      state : IN std_logic_vector(1 DOWNTO 0);
      led : OUT std_logic_vector(20 DOWNTO 0)
    );
  END COMPONENT;

  -- Signals to connect to UUT
  SIGNAL state : std_logic_vector(1 DOWNTO 0) := "00";
  SIGNAL led : std_logic_vector(20 DOWNTO 0);

BEGIN

  -- Instantiate the Unit Under Test (UUT)
  uut: decoder_trabajo PORT MAP (
    state => state,
    led => led
  );

  -- Test process
  stim_proc: PROCESS
  BEGIN
    -- Test case 1: state = "00"
    state <= "00";
    WAIT FOR 100 ns;
    
    -- Test case 2: state = "01"
    state <= "01";
    WAIT FOR 100 ns;

    -- Test case 3: state = "10"
    state <= "10";
    WAIT FOR 100 ns;

    -- Test case 4: state = "11"
    state <= "11";
    WAIT FOR 100 ns;

    -- End simulation
    
     ASSERT false
            REPORT "Simulacin finalizada. Test superado."
            SEVERITY FAILURE;
            
END PROCESS;
END ARCHITECTURE behavior;