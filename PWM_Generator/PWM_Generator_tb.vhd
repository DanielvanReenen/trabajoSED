library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_PWM_Generator is
-- No tiene puertos
end TB_PWM_Generator;

architecture Behavioral of TB_PWM_Generator is
    -- Instancia del componente a probar
    component PWM_Generator
        Port (
            clk       : in  std_logic;                  -- Reloj
            color_val : in  std_logic_vector(11 downto 0); -- Vector de 12 bits inicial
            pwm_red   : out std_logic;                 -- Señal PWM para el color rojo
            pwm_green : out std_logic;                 -- Señal PWM para el color verde
            pwm_blue  : out std_logic                  -- Señal PWM para el color azul
        );
    end component;

    -- Señales para conectar al DUT (Device Under Test)
    signal clk       : std_logic := '0';
    signal color_val : std_logic_vector(11 downto 0) := (others => '0');
    signal pwm_red   : std_logic;
    signal pwm_green : std_logic;
    signal pwm_blue  : std_logic;

    -- Período del reloj
    constant clk_period : time := 10 ns;

begin
    -- Instanciar el DUT
    DUT: PWM_Generator
        port map (
            clk       => clk,
            color_val => color_val,
            pwm_red   => pwm_red,
            pwm_green => pwm_green,
            pwm_blue  => pwm_blue
        );

    -- Proceso para generar el reloj
    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Proceso para generar estímulos
    stimulus_process: process
    begin
        -- Inicialización
        wait for 20 ns;

        -- Caso 1: Intensidades mínimas
        color_val <= "000000000000"; -- Rojo 0, Verde 0, Azul 0
        wait for 200 ns; -- Permitir observar un ciclo completo de PWM

        -- Caso 2: Intensidad baja
        color_val <= "000100010001"; -- Rojo 1, Verde 1, Azul 1
        wait for 200 ns;

        -- Caso 3: Intensidad media
        color_val <= "100010001000"; -- Rojo 8, Verde 8, Azul 8
        wait for 200 ns;

        -- Caso 4: Intensidad máxima
        color_val <= "111111111111"; -- Rojo 15, Verde 15, Azul 15
        wait for 200 ns;

        -- Caso 5: Intensidades mixtas
        color_val <= "101001011100"; -- Rojo 10, Verde 5, Azul 7
        wait for 200 ns;

        -- Caso 6: Cambios dinámicos
        color_val <= "001100110011"; -- Rojo 3, Verde 3, Azul 3
        wait for 200 ns;

        -- Final de la simulación
        wait;
    end process;

end Behavioral;
