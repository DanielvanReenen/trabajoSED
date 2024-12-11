library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DecoderRGB is
    port (
        input   : in  std_logic_vector(1 downto 0); -- Entrada de 2 bits
        display : out std_logic_vector(6 downto 0) -- Salida para 7 segmentos (a, b, c, d, e, f, g)
    );
end DecoderRGB;

architecture Behavioral of DecoderRGB is
begin
    process (input)
    begin
        case input is
            when "10" => -- Mostrar "R"
                display <= "1111010"; 
            when "01" => -- Mostrar "G"
                display <= "0100001"; 
            when "00" => -- Mostrar "B"
                display <= "1100000"; 
            when others => -- Apagar display
                display <= "1111111";
        end case;
    end process;
end Behavioral;
