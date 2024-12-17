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
  signal DUTYS_tb  : std_logic_vector(11 downto 0);
  signal COLOR_tb  : std_logic_vector(1 downto 0);

  -- Constante para el periodo del reloj
  constant clk_period : time := 1 ns;

begin

  -- Instancia de la FSM a probar
  DUT : entity work.FSM_Manual
    port map (
      inputs => inputs_tb,
      SETM   => SETM_tb,
      clk    => clk_tb,
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
    wait for clk_period ;

    -- Activar la máquina de estados
    SETM_tb <= '1';
    wait for clk_period ;
    -- Cambiar al estado ROJO e incrementar su duty
    wait for 20 ns;

    inputs_tb <= "0100";
    wait for 25 ns ;
    inputs_tb <= "0000";
    
    wait for 20 ns ;   
    inputs_tb <= "0010";
    wait for 20 ns ;
    inputs_tb <= "0000";
    
     wait for 20 ns;       
    inputs_tb <= "0010";
    wait for 20 ns;
    inputs_tb <= "0000";
    wait for 20 ns;       
    
    
        wait for 20 ns;

    inputs_tb <= "0100";
    wait for 25 ns ;
    inputs_tb <= "0000";
    
    wait for 20 ns ;   
    inputs_tb <= "0010";
    wait for 20 ns ;
    inputs_tb <= "0000";
    
     wait for 20 ns;       
    inputs_tb <= "0010";
    wait for 20 ns;
    inputs_tb <= "0000";
    wait for 20 ns;       

    
   


    wait;
  end process;

end Behavioral;
