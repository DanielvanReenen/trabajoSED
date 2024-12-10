library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PWM_Generator_tb is
-- Testbench no tiene puertos
end PWM_Generator_tb;

architecture Behavioral of PWM_Generator_tb is

    -- Component del DUT (Device Under Test)
    component PWM_Generator is
        Port (
            clk       : in  std_logic;
            color_val : in  std_logic_vector(11 downto 0);
            pwm_red   : out std_logic;
            pwm_green : out std_logic;
            pwm_blue  : out std_logic
        );
    end component;

    -- Señales internas para conectar con el DUT
    signal clk       : std_logic := '0';
    signal color_val : std_logic_vector(11 downto 0) := (others => '0');
    signal pwm_red   : std_logic;
    signal pwm_green : std_logic;
    signal pwm_blue  : std_logic;

    -- Parámetro de tiempo de reloj
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instancia del DUT
    UUT: PWM_Generator
        port map (
            clk => clk,
            color_val => color_val,
            pwm_red => pwm_red,
            pwm_green => pwm_green,
            pwm_blue => pwm_blue
        );

    -- Generador de reloj
    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Estímulos de prueba
    stim_process: process
    begin
        -- Caso 1: Modificar rojo, verde y azul al mismo tiempo (incrementos)
        color_val <= "000100010001"; -- Intensidad inicial: rojo=1, verde=1, azul=1
        wait for 200 ns;
        color_val <= "001000100010"; -- Incrementar rojo=2, verde=2, azul=2
        wait for 200 ns;
        color_val <= "010001000100"; -- Incrementar rojo=4, verde=4, azul=4
        wait for 200 ns;

        -- Caso 2: Modificar rojo y verde, mantener azul (incremento y decremento)
        color_val <= "011000100100"; -- Incrementar rojo=6, mantener verde=2, mantener azul=4
        wait for 200 ns;
        color_val <= "010000100100"; -- Decrementar rojo=4, mantener verde=2, mantener azul=4
        wait for 200 ns;

        -- Caso 3: Modificar verde y azul al mismo tiempo (decrementos)
        color_val <= "010000010010"; -- Mantener rojo=4, decrementar verde=1, decrementar azul=2
        wait for 200 ns;

        -- Caso 4: Incrementar verde, mantener rojo y azul
        color_val <= "010001000010"; -- Mantener rojo=4, incrementar verde=4, mantener azul=2
        wait for 200 ns;

        -- Caso 5: Rojo en máximo, verde y azul en mínimo
        color_val <= "111100000000"; -- Rojo=15, verde=0, azul=0
        wait for 200 ns;

        -- Caso 6: Todos los colores en máximo
        color_val <= "111111111111"; -- Rojo=15, verde=15, azul=15
        wait for 200 ns;

        -- Caso 7: Todos los colores en mínimo
        color_val <= "000000000000"; -- Rojo=0, verde=0, azul=0
        wait for 200 ns;

        -- Fin de la simulación
        wait;
    end process;

end Behavioral;
