----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.12.2024 23:36:43
-- Design Name: 
-- Module Name: FSM_Manual_tb - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSM_Manual_tb is
end FSM_Manual_tb;

architecture Behavioral of FSM_Manual_tb is
  -- Señales para conectar con la entidad a probar
  signal inputs_tb : std_logic_vector(3 downto 0);
  signal SETM_tb   : std_logic;
  signal clk_tb    : std_logic := '0';
  signal DONE_tb   : std_logic;
  signal DUTYS_tb  : std_logic_vector(11 downto 0);
  signal COLOR_tb  : std_logic_vector(1 downto 0);

  -- Constante para el periodo del reloj
  constant clk_period : time := 10 ns;

begin

  -- Instancia de la FSM a probar
  DUT : entity work.FSM_Manual
    port map (
      inputs => inputs_tb,
      SETM   => SETM_tb,
      clk    => clk_tb,
      DONE   => DONE_tb,
      DUTYS  => DUTYS_tb,
      COLOR  => COLOR_tb
    );

  -- Generador de reloj
  clk_process : process
  begin
    for i in 0 to 100 loop -- Número limitado de ciclos
      clk_tb <= '0';
      wait for clk_period / 2;
      clk_tb <= '1';
      wait for clk_period / 2;
    end loop;
    wait; -- Termina el proceso
  end process;

  -- Proceso de estímulos
  stimulus_process : process
  begin
    -- Inicialización
    SETM_tb <= '0';
    inputs_tb <= (others => '0');
    wait for 20 ns;

    -- Activar la máquina de estados
    SETM_tb <= '1';

    -- Cambiar al estado ROJO e incrementar su duty
    inputs_tb <= "0100";
    wait for clk_period;
    inputs_tb <= "0010";
    wait for clk_period;

    -- Cambiar al estado VERDE e incrementar su duty
    inputs_tb <= "0100"; 
    wait for clk_period;
    inputs_tb <= "0010";
    wait for clk_period;

    -- Cambiar al estado AZUL e incrementar su duty
    inputs_tb <= "0100"; 
    wait for clk_period;
    inputs_tb <= "0010";
    wait for clk_period;

    -- Salir 
    inputs_tb <= "0100";  
    wait for clk_period;
    
    inputs_tb <= "0000";
    wait for 3 * clk_period;
    
    -- Cambiar al estado AZUL y disminuir su duty
    inputs_tb <= "1000";  
    wait for clk_period;
    inputs_tb <= "0010";
    wait for 2 * clk_period;

    -- Cambiar al estado VERDE y dismuinuir su duty
    inputs_tb <= "1000";
    wait for clk_period;  
    inputs_tb <= "0010";
    wait for clk_period;

    -- Cambiar al estado ROJO y disminuir su duty
    inputs_tb <= "1000";  
    wait for clk_period;
    inputs_tb <= "0010";
    wait for clk_period;
    
    -- Salir 
    inputs_tb <= "1000";  
    wait for 2 * clk_period;
    
    inputs_tb <= "0000";
    wait for 3 * clk_period;
    
-- Repetir el ciclo pero cambiando valores
     
    -- Cambiar al estado ROJO e incrementar su duty
    inputs_tb <= "0100";
    wait for 2 * clk_period;
    inputs_tb <= "0010";
    wait for clk_period;
    inputs_tb <= "0000";
    wait for clk_period;
    inputs_tb <= "0010";
    wait for clk_period;
    

    -- Cambiar al estado VERDE e incrementar su duty
    inputs_tb <= "0100"; 
    wait for clk_period;
    inputs_tb <= "0010";

    wait for clk_period;

    -- Cambiar al estado AZUL e incrementar su duty
    inputs_tb <= "0100"; 
    wait for clk_period;
    inputs_tb <= "0010";
    wait for clk_period;
    inputs_tb <= "0000";
    wait for clk_period;
    inputs_tb <= "0010";
    wait for clk_period;
    inputs_tb <= "0000";
    wait for clk_period;
    inputs_tb <= "0010";
    wait for clk_period;

    -- Salir 
    inputs_tb <= "0100";  
    wait for clk_period;
    
    inputs_tb <= "0000";
    wait for 3 * clk_period;
    
    -- Cambiar al estado AZUL y disminuir su duty
    inputs_tb <= "1000";  
    wait for clk_period;
    inputs_tb <= "0001";
    wait for clk_period;

    -- Cambiar al estado VERDE y dismuinuir su duty
    inputs_tb <= "1000";
    wait for clk_period;  
    inputs_tb <= "0001";
    wait for clk_period;

    -- Cambiar al estado ROJO y disminuir su duty
    inputs_tb <= "1000";  
    wait for clk_period;
    inputs_tb <= "0001";
    wait for clk_period;
    
    -- Salir 
    inputs_tb <= "1000";  
    wait for 2 * clk_period;
    
    inputs_tb <= "0000";
    wait for 3 * clk_period;


    -- Finalizar la simulación
    assert false 
        report "Fin de la simulación." 
        severity failure;
 
  end process;

end Behavioral;
