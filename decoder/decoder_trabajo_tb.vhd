----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.11.2024 21:38:51
-- Design Name: 
-- Module Name: P2_tb - Behavioral
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

entity decodificador_tb is
end decodificador_tb;

architecture Behavioral of decodificador_tb is

    signal clk       : STD_LOGIC := '0';
    signal reset     : STD_LOGIC := '0';
    signal state     : STD_LOGIC_VECTOR(1 downto 0);
    signal color     : STD_LOGIC_VECTOR(1 downto 0);
    signal anodes    : STD_LOGIC_VECTOR(3 downto 0);
    signal segments  : STD_LOGIC_VECTOR(6 downto 0);

    -- Período del reloj
    constant clk_period : time := 10 ns;

begin

    -- Unit Under test
    UUT: entity work.decodificador
        port map (
            clk       => clk,
            reset     => reset,
            state     => state,
            color     => color,
            anodes    => anodes,
            segments  => segments
        );

    -- Generador de reloj
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Estímulos
    stimulus_process : process
    begin
        -- Inicialización
        reset <= '1';
        wait for clk_period * 2;
        reset <= '0';

        -- Caso 1: Modo REP, Color aleatorio
        state <= "00";  -- REP
        color <= "00"; -- 
        wait for clk_period * 100; 

        -- Caso 2: Modo MAN, Rotación de colores
        state <= "01";  -- MAN
        color <= "00"; -- B
        wait for clk_period * 100;
        color <= "01"; -- G
        wait for clk_period * 100;
        color <= "10"; -- R
        wait for clk_period * 100;

        -- Caso 3: Modo AUT, Color aleatorio
        state <= "10";  -- AUT
        color <= "01"; -- G
        wait for clk_period * 100;

        -- Caso 4: Modo ERR, Color aleatorio
        state <= "11";  -- ERR
        color <= "10"; -- R
        wait for clk_period * 100;

        ASSERT false
            REPORT "Simulacin finalizada. Test superado."
            SEVERITY FAILURE;
            
    end process;
end Behavioral;

