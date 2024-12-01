----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.11.2024 23:22:44
-- Design Name: 
-- Module Name: PWM_tb - Behavioral
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

entity PWM_tb is
end PWM_tb;

architecture Behavioral of PWM_tb is

    -- Señales para la prueba
    signal clk      : STD_LOGIC := '0';
    signal reset    : STD_LOGIC := '0';
    signal duty     : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal pwm_out  : STD_LOGIC;

    -- Parámetro para el periodo del reloj
    constant clk_period : time := 10 ns;

begin

    -- Instancia del DUT (Device Under Test)
    DUT: entity work.PWM
        port map (
            clk      => clk,
            reset    => reset,
            duty     => duty,
            pwm_out  => pwm_out
        );

    -- Generación de la señal de reloj
    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Estímulos para probar el diseño
    stim_proc: process
    begin
        -- Reinicio inicial
        reset <= '1';
        wait for clk_period * 2;
        reset <= '0';

        -- Test 1: Ciclo de trabajo 0% (duty = 0)
        duty <= "0000";
        wait for clk_period * 16; -- Observa al menos un ciclo completo del PWM

        -- Test 2: Ciclo de trabajo 25% (duty = 4)
        duty <= "0100";
        wait for clk_period * 16; -- Observa al menos un ciclo completo del PWM

        -- Test 3: Ciclo de trabajo 50% (duty = 8)
        duty <= "1000";
        wait for clk_period * 16; -- Observa al menos un ciclo completo del PWM

        -- Test 4: Ciclo de trabajo 75% (duty = 12)
        duty <= "1100";
        wait for clk_period * 16; -- Observa al menos un ciclo completo del PWM

        -- Test 5: Ciclo de trabajo 100% (duty = 15)
        duty <= "1111";
        wait for clk_period * 16; -- Observa al menos un ciclo completo del PWM

        duty <= "0000";
        -- Finaliza la simulación
        wait;
    end process;

end Behavioral;
