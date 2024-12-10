----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.12.2024 19:15:18
-- Design Name: 
-- Module Name: duty_to_LED_tb - Behavioral
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

ENTITY tb_duty_to_LED IS
END ENTITY tb_duty_to_LED;

ARCHITECTURE behavior OF tb_duty_to_LED IS

  COMPONENT duty_to_LED
    PORT (
      duty : IN std_logic_vector(3 DOWNTO 0);
      led : OUT std_logic_vector(15 DOWNTO 0)
    );
  END COMPONENT;

  SIGNAL duty : std_logic_vector(3 DOWNTO 0) := "0000";
  SIGNAL led : std_logic_vector(15 DOWNTO 0);

BEGIN

  uut: duty_to_LED PORT MAP (
    duty => duty,
    led => led
  );

  stim_proc: PROCESS
  BEGIN
    -- Caso "0000"
    WAIT FOR 60 ns;
    
    -- Caso "0001"
    duty <= "0001";
    WAIT FOR 60 ns;
    
    -- Caso "0010"
    duty <= "0010";
    WAIT FOR 60 ns;

    -- Caso "0011"
    duty <= "0011";
    WAIT FOR 60 ns;

    -- Caso "0100"
    duty <= "0100";
    WAIT FOR 60 ns;

    -- Caso "0101" 
    duty <= "0101";
    WAIT FOR 60 ns;
    
    -- Caso "0110" 
    duty <= "0110";
    WAIT FOR 60 ns;
    
    -- Caso "0111" 
    duty <= "0111";
    WAIT FOR 60 ns;
    
    -- Caso "1000" 
    duty <= "1000";
    WAIT FOR 60 ns;
    
    -- Caso "1001" 
    duty <= "1001";
    WAIT FOR 60 ns;
    
    -- Caso "1010" 
    duty <= "1010";
    WAIT FOR 60 ns;
    
    -- Caso "1011" 
    duty <= "1011";
    WAIT FOR 60 ns;
    
    -- Caso "1100" 
    duty <= "1100";
    WAIT FOR 60 ns;
    
    -- Caso "1101" 
    duty <= "1101";
    WAIT FOR 60 ns;
    
    -- Caso "1110" 
    duty <= "1110";
    WAIT FOR 60 ns;
    
    -- Caso "1111"
    duty <= "1111";
    WAIT FOR 60 ns;


     ASSERT false
            REPORT "Simulacin finalizada. Test superado."
            SEVERITY FAILURE;
            
END PROCESS;
END ARCHITECTURE behavior;

