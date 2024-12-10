library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PWM_Generator is
    Port (
        clk       : in  std_logic;                  -- Reloj
        color_val : in  std_logic_vector(11 downto 0); -- Vector de 12 bits inicial (4 bits por color)
        pwm_red   : out std_logic;                 -- Señal PWM para el color rojo
        pwm_green : out std_logic;                 -- Señal PWM para el color verde
        pwm_blue  : out std_logic                  -- Señal PWM para el color azul
    );
end PWM_Generator;

architecture Behavioral of PWM_Generator is
    signal counter: unsigned(3 downto 0) := (others => '0'); -- Contador de 4 bits (0 a 15)
    signal red_intensity   : unsigned(3 downto 0); -- Intensidad del color rojo
    signal green_intensity : unsigned(3 downto 0); -- Intensidad del color verde
    signal blue_intensity  : unsigned(3 downto 0); -- Intensidad del color azul
begin

    process(clk)
    begin
        if rising_edge(clk) then
            -- Extraer los valores de intensidad del vector de entrada
            red_intensity <= unsigned(color_val(11 downto 8)); -- Bits 11-8 para rojo
            green_intensity <= unsigned(color_val(7 downto 4)); -- Bits 7-4 para verde
            blue_intensity <= unsigned(color_val(3 downto 0)); -- Bits 3-0 para azul

            -- Generar PWM para el color rojo
            if counter < red_intensity then
                pwm_red <= '1';
            else
                pwm_red <= '0';
            end if;

            -- Generar PWM para el color verde
            if counter < green_intensity then
                pwm_green <= '1';
            else
                pwm_green <= '0';
            end if;

            -- Generar PWM para el color azul
            if counter < blue_intensity then
                pwm_blue <= '1';
            else
                pwm_blue <= '0';
            end if;

            -- Incrementar el contador y reiniciar si alcanza el máximo valor
            if counter = 15 then
                counter <= (others => '0');
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

end Behavioral;
