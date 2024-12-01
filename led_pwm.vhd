library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity led_pwm is
    port (
        CLK : in std_logic;
        RESET : in std_logic;
        LIGHT_STATE : in std_logic_vector(2 downto 0); -- Entrada de estado de la luz
        INCREMENT : in std_logic; -- Botón para aumentar el PWM
        DECREMENT : in std_logic; -- Botón para disminuir el PWM
        PWM_OUT : out std_logic -- Salida PWM
    );
end led_pwm;

architecture behavioral of led_pwm is
    signal counter : unsigned(3 downto 0) := (others => '0'); -- Contador de 4 bits
    signal duty_cycle : unsigned(3 downto 0) := (others => '0'); -- Ciclo de trabajo
begin

    -- Generador de PWM
    process (CLK, RESET)
    begin
        if RESET = '0' then
            counter <= (others => '0');
        elsif rising_edge(CLK) then
            counter <= counter + 1;
        end if;
    end process;

    -- Ajuste manual del ciclo de trabajo con botones
    process (CLK, RESET)
    begin
        if RESET = '0' then
            duty_cycle <= (others => '0'); -- Inicializar ciclo de trabajo a 0
        elsif rising_edge(CLK) then
            if INCREMENT = '1' and duty_cycle < "1111" then -- Incrementar hasta 15
                duty_cycle <= duty_cycle + 1;
            elsif DECREMENT = '1' and duty_cycle > "0000" then -- Decrementar hasta 0
                duty_cycle <= duty_cycle - 1;
            end if;
        end if;
    end process;

    -- Generación del PWM según el ciclo de trabajo
    PWM_OUT <= '1' when counter < duty_cycle else '0';

end behavioral;
