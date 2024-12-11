library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DecoderRGB_tb is
end DecoderRGB_tb;

architecture Behavioral of DecoderRGB_tb is
    -- Señales internas para conectar con el DUT
    signal input   : std_logic_vector(1 downto 0) := "00";
    signal display : std_logic_vector(6 downto 0);

    -- Declaración del DUT (Device Under Test)
    component DecoderRGB
        port (
            input   : in  std_logic_vector(1 downto 0); -- Entrada de 2 bits
            display : out std_logic_vector(6 downto 0) -- Salida para 7 segmentos
        );
    end component;

begin
    -- Instancia del DUT
    DUT: DecoderRGB
        port map (
            input   => input,
            display => display
        );

    -- Proceso de estímulos
    stimulus_process: process
    begin
        -- Caso 1: input = "10" (Mostrar R)
        input <= "10";
        wait for 50 ns;

        -- Caso 2: input = "01" (Mostrar G)
        input <= "01";
        wait for 50 ns;

        -- Caso 3: input = "11" (Mostrar B)
        input <= "00";
        wait for 50 ns;

        -- Caso 4: input = "00" (Apagar Display)
        input <= "11";
        wait for 50 ns;

        -- Finalizar la simulación
        wait;
    end process;

end Behavioral;
