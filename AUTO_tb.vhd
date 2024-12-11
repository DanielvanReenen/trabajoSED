library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AUTO_tb is
-- No ports for the test bench
end AUTO_tb;

architecture Behavioral of AUTO_tb is
    -- Component declaration
    component AUTO
        Port (
            clk : in std_logic;
            reset : in std_logic;
            btn_avanzar : in std_logic;
            btn_retroceder : in std_logic;
            modo_activo : in std_logic;
            salida_vector : out std_logic_vector(11 downto 0);
            salida_salir : out std_logic
        );
    end component;

    -- Signals for test bench
    signal clk_tb : std_logic := '0';
    signal reset_tb : std_logic := '0';
    signal btn_avanzar_tb : std_logic := '0';
    signal btn_retroceder_tb : std_logic := '0';
    signal modo_activo_tb : std_logic := '0';
    signal salida_vector_tb : std_logic_vector(11 downto 0);
    signal salida_salir_tb : std_logic;

    -- Clock period constant
    constant CLK_PERIOD : time := 10 ns;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: AUTO
        Port map (
            clk => clk_tb,
            reset => reset_tb,
            btn_avanzar => btn_avanzar_tb,
            btn_retroceder => btn_retroceder_tb,
            modo_activo => modo_activo_tb,
            salida_vector => salida_vector_tb,
            salida_salir => salida_salir_tb
        );

    -- Clock generation process
    clk_process : process
    begin
        while true loop
            clk_tb <= '0';
            wait for CLK_PERIOD / 2;
            clk_tb <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Stimulus process
    stimulus_process : process
    begin
        -- Step 1: Reset the system
        reset_tb <= '1';
        wait for 20 ns;
        reset_tb <= '0';
        wait for 20 ns;

        -- Step 2: Activate modo_activo and go to AUTO1
        modo_activo_tb <= '1';
        wait for 20 ns;

        -- Step 3: Transition from REPOSO to AUTO1
        btn_avanzar_tb <= '1';
        wait for CLK_PERIOD;
        btn_avanzar_tb <= '0';
        wait for 40 ns;

        -- Step 4: Transition from AUTO1 to AUTO2
        btn_avanzar_tb <= '1';
        wait for CLK_PERIOD;
        btn_avanzar_tb <= '0';
        wait for 40 ns;

        -- Step 5: Return from AUTO2 to AUTO1
        btn_retroceder_tb <= '1';
        wait for CLK_PERIOD;
        btn_retroceder_tb <= '0';
        wait for 40 ns;

        -- Step 6: Transition back to AUTO2
        btn_avanzar_tb <= '1';
        wait for CLK_PERIOD;
        btn_avanzar_tb <= '0';
        wait for 40 ns;

        -- Step 7: Transition to SALIR
        btn_avanzar_tb <= '1';
        wait for CLK_PERIOD;
        btn_avanzar_tb <= '0';
        wait for 40 ns;

        -- Step 8: Return to REPOSO from SALIR
        modo_activo_tb <= '0';
        wait for 40 ns;

        -- Step 9: Reactivate modo_activo and alternate between AUTO1 and AUTO2
        modo_activo_tb <= '1';
        wait for 20 ns;

        btn_avanzar_tb <= '1'; -- AUTO1 to AUTO2
        wait for CLK_PERIOD;
        btn_avanzar_tb <= '0';
        wait for 40 ns;

        btn_retroceder_tb <= '1'; -- AUTO2 to AUTO1
        wait for CLK_PERIOD;
        btn_retroceder_tb <= '0';
        wait for 40 ns;

        -- Step 10: End simulation
        wait;
    end process;

end Behavioral;
