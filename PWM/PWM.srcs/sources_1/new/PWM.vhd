----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.11.2024 22:26:11
-- Design Name: 
-- Module Name: PWM - Behavioral
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

entity PWM is
    generic(
      pwm_bits : positive := 3
    );
    Port (
        clk      : in  STD_LOGIC;
        reset    : in  STD_LOGIC;
        duty     : in  STD_LOGIC_VECTOR(pwm_bits downto 0); -- 4 bits para el ciclo de trabajo
        pwm_out  : out STD_LOGIC
    );
end PWM;

architecture Behavioral of PWM is
    signal counter : UNSIGNED(pwm_bits downto 0) := (others => '0'); -- Contador de 4 bits
begin
    process(clk, reset)
    begin
        if reset = '1' then
            counter <= (others => '0');
        elsif rising_edge(clk) then
            counter <= counter + 1;
        end if;
    end process;

    pwm_out <= '1' when counter < UNSIGNED(duty) or (duty = "1111") else '0';
end Behavioral;
