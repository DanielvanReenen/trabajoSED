library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity AUTO is
    Port (
        clk : in std_logic;
        reset : in std_logic;
        btn_avanzar : in std_logic;
        btn_retroceder : in std_logic;
        modo_activo : in std_logic; -- Señal desde la máquina "master"
        salida_vector : out std_logic_vector(11 downto 0); -- Salida principal
        salida_salir : out std_logic -- Señal para indicar el estado SALIR
    );
end AUTO;

architecture Behavioral of AUTO is
    -- Definición de los estados
    type state_type is (REPOSO, AUTO1, AUTO2, SALIR);
    signal current_state, next_state : state_type;

    -- Señales para generar valores aleatorios
    signal random_value_auto1 : std_logic_vector(11 downto 0) := "000000000001";
    signal random_value_auto2 : std_logic_vector(11 downto 0) := "000000000010";

    -- Señal para almacenar el último valor de salida
    signal last_value : std_logic_vector(11 downto 0) := (others => '0');

    -- Filtro anti-rebote para los botones
    signal btn_avanzar_sync : std_logic := '0';
    signal btn_retroceder_sync : std_logic := '0';

begin

    -- Proceso para la lógica de estado
    state_logic : process(clk, reset)
    begin
        if reset = '1' then
            current_state <= REPOSO;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    -- Proceso para la transición entre estados
    state_transition : process(current_state, btn_avanzar_sync, btn_retroceder_sync, modo_activo)
    begin
        case current_state is
            when REPOSO =>
                if modo_activo = '1' then
                    next_state <= AUTO1;
                else
                    next_state <= REPOSO;
                end if;

            when AUTO1 =>
                if btn_avanzar_sync = '1' then
                    next_state <= AUTO2;
                elsif btn_retroceder_sync = '1' then
                    next_state <= REPOSO;
                else
                    next_state <= AUTO1;
                end if;

            when AUTO2 =>
                if btn_avanzar_sync = '1' then
                    next_state <= SALIR; -- Ir al estado SALIR
                elsif btn_retroceder_sync = '1' then
                    next_state <= AUTO1;
                else
                    next_state <= AUTO2;
                end if;

            when SALIR =>
                if modo_activo = '0' then
                    next_state <= REPOSO;
                else
                    next_state <= SALIR; -- Mantenerse en SALIR mientras no se desactive
                end if;

            when others =>
                next_state <= REPOSO;
        end case;
    end process;

    -- Proceso para la lógica de salida
    output_logic : process(clk)
    begin
        if rising_edge(clk) then
            case current_state is
                when REPOSO =>
                    salida_vector <= last_value; -- Mantener el último valor
                    salida_salir <= '0'; -- Señal de SALIR apagada

                when AUTO1 =>
                    salida_vector <= random_value_auto1; -- Generar valores aleatorios
                    salida_salir <= '0'; -- Señal de SALIR apagada
                    last_value <= random_value_auto1; -- Guardar el último valor

                when AUTO2 =>
                    salida_vector <= random_value_auto2; -- Generar valores aleatorios
                    salida_salir <= '0'; -- Señal de SALIR apagada
                    last_value <= random_value_auto2; -- Guardar el último valor

                when SALIR =>
                    salida_vector <= last_value; -- Mantener el último valor en el vector
                    salida_salir <= '1'; -- Señal de SALIR activada

                when others =>
                    salida_vector <= (others => '0'); -- Default
                    salida_salir <= '0'; -- Señal de SALIR apagada
            end case;
        end if;
    end process;

    -- Generador aleatorio para AUTO1
    random_generator_auto1 : process(clk)
    begin
        if rising_edge(clk) then
            if current_state = AUTO1 then
                random_value_auto1 <= (random_value_auto1(2) xor random_value_auto1(10) xor random_value_auto1(1) xor random_value_auto1(5)) &
                      random_value_auto1(9 downto 0) &
                      (random_value_auto1(11) xor random_value_auto2(3) xor random_value_auto2(6) xor random_value_auto2(0));

                 end if;
        end if;
    end process;

    -- Generador aleatorio para AUTO2
    random_generator_auto2 : process(clk)
    begin
        if rising_edge(clk) then
            if current_state = AUTO2 then
                random_value_auto2 <= random_value_auto2(9 downto 0) &
                                     (random_value_auto2(11) xor random_value_auto2(7) xor random_value_auto2(5) xor random_value_auto2(4)) &
                                     (random_value_auto2(0) xor random_value_auto2(10) xor random_value_auto2(2) xor random_value_auto2(1));
            end if;
        end if;
    end process;

    -- Filtro anti-rebote para botones
    debounce_process : process(clk)
    begin
        if rising_edge(clk) then
            btn_avanzar_sync <= btn_avanzar;
            btn_retroceder_sync <= btn_retroceder;
        end if;
    end process;

end Behavioral;