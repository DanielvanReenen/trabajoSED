----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.12.2024 13:10:32
-- Design Name: 
-- Module Name: decoder_trabajo - dataflow
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

entity decodificador is
    Port (
        clk       : in STD_LOGIC; -- Reloj
        reset     : in STD_LOGIC; -- Reset
        state     : in STD_LOGIC_VECTOR(1 downto 0); -- Modo: "00"->REP, "01"->MAN, "10"->AUT, "11"->ERR
        color     : in STD_LOGIC_VECTOR(1 downto 0); -- Color: "00"->B, "01"->G, "10"->R
        anodes    : out STD_LOGIC_VECTOR(3 downto 0); -- Control de los ánodos
        segments  : out STD_LOGIC_VECTOR(6 downto 0) -- Señales para los segmentos 
    );
end decodificador;

architecture Behavioral of decodificador is
    signal refresh : unsigned(15 downto 0) := (others => '0');  -- Divisor de reloj
    signal digit    : STD_LOGIC_VECTOR(3 downto 0); -- Dígito activo (4 displays)
    signal seg_temp : STD_LOGIC_VECTOR(6 downto 0); -- Segmentos temporales

begin

    -- Proceso para generar el divisor de clk y seleccionar el ánodo activo
    process(clk, reset)
    begin
        if reset = '1' then
            refresh <= (others => '0');
            digit <= "0001"; -- Primer display activo
        elsif rising_edge(clk) then
            if refresh = "1111" then 
              refresh <= (others => '0');
            else refresh <= refresh + 1;
            end if;
            if refresh = 0 then
                -- Rotar el ánodo activo
                digit <= digit(2 downto 0) & digit(3);
            end if;
        end if;
    end process;

    -- Proceso para generar los segmentos según el state y el color
    process(digit, state, color)
    begin
        case digit is
            when "0001" => -- Primer display
                case state is
                    when "00" => seg_temp <= "1111010"; -- R
                    when "01" => seg_temp <= "1001000"; -- M
                    when "10" => seg_temp <= "0001000"; -- A
                    when others => seg_temp <= "0110000"; -- E
                end case;
            when "0010" => -- Segundo display
                case state is
                    when "00" => seg_temp <= "0110000"; -- E
                    when "01" => seg_temp <= "0001000"; -- A
                    when "10" => seg_temp <= "1000001"; -- U
                    when others => seg_temp <= "1111010"; -- R
                end case;
            when "0100" => -- Tercer display
                case state is
                    when "00" => seg_temp <= "0011000"; -- P
                    when "01" => seg_temp <= "1101010"; -- N
                    when "10" => seg_temp <= "0001111"; -- T
                    when others => seg_temp <= "1111010"; -- R
                end case;
            when others => -- Cuarto display
                case state is when "01" => -- Caso Manual
                  case color is
                      when "00" => seg_temp <= "1100000"; -- B
                      when "01" => seg_temp <= "0000100"; -- G
                      when "10" => seg_temp <= "1111010"; -- R
                      when others => seg_temp <= "1111111"; -- Apagado
                  end case;
                 when others => seg_temp <= "1111111"; -- En otro caso permanecerá apagado
                end case;
        end case;
    end process;

    anodes <= digit;
    segments <= seg_temp;

end Behavioral;
