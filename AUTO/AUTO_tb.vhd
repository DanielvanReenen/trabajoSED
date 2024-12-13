library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AUTO_tb is
end AUTO_tb;

architecture Behavioral of AUTO_tb is
    -- Declaración del componente a probar
    component AUTO
        Port (
            clk : in std_logic;
            reset : in std_logic;
            btn_avanzar : in std_logic;
            btn_retroceder : in std_logic;
            salida_vector : out std_logic_vector(11 downto 0);
            salida_salir : out std_logic
        );
    end component;

    -- Señales internas del testbench
    signal clk_tb : std_logic := '0';
    signal reset_tb : std_logic := '0';
    signal btn_avanzar_tb : std_logic := '0';
    signal btn_retroceder_tb : std_logic := '0';
    signal salida_vector_tb : std_logic_vector(11 downto 0);
    signal salida_salir_tb : std_logic;

    -- Constante para el periodo del reloj
    constant CLK_PERIOD : time := 10 ns;

begin
    -- Instancia del módulo AUTO
    uut: AUTO
        Port map (
            clk => clk_tb,
            reset => reset_tb,
            btn_avanzar => btn_avanzar_tb,
            btn_retroceder => btn_retroceder_tb,
            salida_vector => salida_vector_tb,
            salida_salir => salida_salir_tb
        );

    -- Generación del reloj
    clk_process : process
    begin
        while true loop
            clk_tb <= '0';
            wait for CLK_PERIOD / 2;
            clk_tb <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Estímulos de prueba
    stimulus_process : process
    begin
        -- Paso 1: Reset del sistema
        report "Paso 1: Reset del sistema";
        reset_tb <= '1';
        wait for 20 ns;
        reset_tb <= '0';
        wait for 20 ns;

        -- Paso 2: Transitar a AUTO1
        report "Paso 2: Transitar a AUTO1";
        btn_avanzar_tb <= '1';
        wait for CLK_PERIOD;
        btn_avanzar_tb <= '0';
        wait for 200 ns; 

        -- Paso 3: Transitar a AUTO2
        report "Paso 3: Transitar a AUTO2";
        btn_avanzar_tb <= '1';
        wait for CLK_PERIOD;
        btn_avanzar_tb <= '0';
        wait for 200 ns; 

        -- Paso 4: Ir al estado SALIR
        report "Paso 4: Transitar a SALIR";
        btn_avanzar_tb <= '1';
        wait for CLK_PERIOD;
        btn_avanzar_tb <= '0';
        wait for 40 ns;

        -- Paso 5: Permanecer en SALIR
        report "Paso 5: Permanecer en estado SALIR";
        wait for 100 ns;

        -- Paso 6: Reset desde el bloque maestro
        report "Paso 6: Reset desde el bloque maestro para volver a REPOSO";
        reset_tb <= '1';
        wait for 20 ns;
        reset_tb <= '0';
        wait for 40 ns;

        -- Paso 7: Repetir transiciones
        report "Paso 7: Repetir transiciones para validar funcionalidad";
        btn_avanzar_tb <= '1';
        wait for CLK_PERIOD;
        btn_avanzar_tb <= '0';
        wait for 200 ns; 

        btn_retroceder_tb <= '1';
        wait for CLK_PERIOD;
        btn_retroceder_tb <= '0';
        wait for 200 ns; 

        -- Fin de la simulación
        report "Fin de la simulación.";
        wait;
    end process;

end Behavioral;
