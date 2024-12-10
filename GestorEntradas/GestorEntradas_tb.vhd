library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity GestorEntradas_tb is
end GestorEntradas_tb;

architecture Behavioral of GestorEntradas_tb is
    -- Parámetros del diseño
    constant N : integer := 5; -- Número de señales de entrada/salida
    
    -- Señales internas
    signal INPUTS  : std_logic_vector(N-1 downto 0) := (others => '0');
    signal CLK_IN  : std_logic := '0';
    signal OUTPUTS : std_logic_vector(N-1 downto 0);
    signal CLK_OUT : std_logic;

    -- Declaración del DUT (Device Under Test)
    component GestorEntradas
        generic (
            N : integer := 5
        );
        port (
            INPUTS  : in  std_logic_vector(N-1 downto 0);
            CLK_IN  : in  std_logic;
            OUTPUTS : out std_logic_vector(N-1 downto 0);
            CLK_OUT : out std_logic
        );
    end component;

begin
    -- Instancia del DUT
    DUT: GestorEntradas
        generic map (
            N => N
        )
        port map (
            INPUTS  => INPUTS,
            CLK_IN  => CLK_IN,
            OUTPUTS => OUTPUTS,
            CLK_OUT => CLK_OUT
        );

    -- Generador de reloj
-- Generador de reloj alternativo
    CLK_GEN: process
    begin
        loop
            CLK_IN <= '0';  -- Estado bajo del reloj
            wait for 10 ns; -- Esperar medio período
            CLK_IN <= '1';  -- Estado alto del reloj
            wait for 10 ns; -- Esperar medio período
        end loop;
    end process;


    -- Estímulos para las entradas
    STIMULUS: process
    begin
        -- Caso 1: Inicializar señales
        wait for 20 ns;
        INPUTS <= "00000"; -- Todas las señales en bajo

        -- Caso 2: Activar un flanco en la señal INPUTS(0)
        wait for 34 ns;
        INPUTS(0) <= '1'; -- Cambia de 0 -> 1

        -- Caso 3: Activar un flanco en la señal INPUTS(1)
        wait for 43 ns;
        INPUTS(1) <= '1'; -- Cambia de 0 -> 1

        -- Caso 4: Volver a poner señales en bajo
        wait for 50 ns;
        INPUTS(0) <= '0';
        wait for 57 ns;

        INPUTS(4) <= '1';
        wait for 50 ns;
        INPUTS(4) <= '0';
        wait for 57 ns;

        INPUTS(1) <= '0';

        -- Caso 5: Generar flancos en señales múltiples


        -- Finalizar simulación
        wait for 100 ns;
        wait;
    end process;
end Behavioral;
