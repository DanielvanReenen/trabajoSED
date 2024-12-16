library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TB_AUTO is
    -- No ports, es un testbench
end TB_AUTO;

architecture Behavioral of TB_AUTO is
    -- Declaración de señales locales para conectar con el DUT
    signal clk : std_logic := '0';
    signal inputs : std_logic_vector(3 downto 0) := (others => '0');
    signal SETA : std_logic := '0';
    signal salida_vector : std_logic_vector(11 downto 0);

    -- Declaración de constantes para tiempos de simulación
    constant clk_period : time := 10 ns;

    -- Instancia del DUT
    component AUTO
        Port (
            clk : in std_logic;
            inputs : in std_logic_vector(3 downto 0);
            SETA : in std_logic;
            salida_vector : out std_logic_vector(11 downto 0)
        );
    end component;

begin
    -- Conexión del DUT
    DUT: AUTO
        port map (
            clk => clk,
            inputs => inputs,
            SETA => SETA,
            salida_vector => salida_vector
        );

    -- Generador de reloj
    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Proceso de estímulo
    stimulus_process: process
    begin
        -- Inicialización
        SETA <= '0';
        inputs <= (others => '0');
        wait for 20 ns;

        -- Salir de RESET
        SETA <= '1';
        wait for clk_period;

        -- 1. REPOSO → AUTO1
        inputs <= "0100";  -- AUTO1
        wait for 50 * clk_period;

        -- 2. AUTO1 → AUTO2
        inputs <= "0100";  -- Mantener en AUTO2
        wait for 50 * clk_period;

        -- 3. AUTO2 → REPOSO
        inputs <= "1000";  -- REPOSO
        wait for 50 * clk_period;

        -- 4. REPOSO → AUTO2
        inputs <= "0100";  -- AUTO1 → AUTO2
        wait for 50 * clk_period;
        inputs <= "0100";  -- Mantener en AUTO2
        wait for 50 * clk_period;

        -- 5. AUTO2 → AUTO1
        inputs <= "1000";  -- REPOSO intermedio
        wait for 50 * clk_period;

        inputs <= "0100";  -- AUTO1
        wait for 50 * clk_period;

        -- 6. AUTO1 → REPOSO
        inputs <= "1000";  -- REPOSO
        wait for 50 * clk_period;

        -- Final de la simulación
        report "Simulación completada con la secuencia deseada";
        wait;
    end process;

end Behavioral;
