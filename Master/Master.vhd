library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Master is
    port (
        inputs_in  : in  std_logic_vector(3 downto 0); -- Entradas del sistema
        inputs_out : out std_logic_vector(3 downto 0); -- Copia de las entradas
        clk        : in  std_logic;
        reset      : in  std_logic;
        color_in   : in  std_logic_vector(1 downto 0); -- Color recibido de otra FSM
        dutys_in   : in  std_logic_vector(11 downto 0); -- Duty recibido de otra FSM
        DONE_M     : in  std_logic; -- FSM Manual ha terminado
        DONE_A     : in  std_logic; -- FSM Automático ha terminado

        mode       : out std_logic_vector(1 downto 0); -- Indica el modo en el que está: 00 Reposo, 01 Manual, 10 Automático
        color      : out std_logic_vector(1 downto 0); -- Indica el color en el que está la FSM
        dutys      : out std_logic_vector(11 downto 0); -- Duty asignado
        duty       : out std_logic_vector(3 downto 0); -- Duty específico para color en estado MAN
        SET_M      : out std_logic; -- Pulso en estado Manual
        SET_A      : out std_logic  -- Pulso en estado Automático
    );
end Master;

architecture Behavioral of Master is
    type STATES is (REP, MAN, AUT);
    signal current_state : STATES := REP;
    signal next_state    : STATES;
begin
    -- Registro de estado
    state_register: process (reset, clk)
    begin
        if reset = '0' then
            current_state <= REP; 
        elsif rising_edge(clk) then
            current_state <= next_state; 
        end if;
    end process;

    -- Lógica de transición de estados
    nextstate_decod: process (inputs_in, current_state, DONE_M, DONE_A)
    begin
        next_state <= current_state; -- Default: Mantener estado
        case current_state is
            when REP =>
                if inputs_in(2) = '1' then
                    next_state <= MAN; -- Avanzar a MAN
                elsif inputs_in(3) = '1' then
                    next_state <= AUT; -- Retroceder a AUT
                end if;
            when MAN =>
                if DONE_M = '1' then -- Solo avanzar si DONE_M está activo
                    if inputs_in(2) = '1' then
                        next_state <= AUT; -- Avanzar a AUT
                    elsif inputs_in(3) = '1' then
                        next_state <= REP; -- Retroceder a REP
                    end if;
                end if;
            when AUT =>
                if DONE_A = '1' then -- Solo avanzar si DONE_A está activo
                    if inputs_in(2) = '1' then
                        next_state <= REP; -- Avanzar a REP
                    elsif inputs_in(3) = '1' then
                        next_state <= MAN; -- Retroceder a MAN
                    end if;
                end if;
            when others =>
                next_state <= REP; -- Estado por defecto
        end case;
    end process;

    -- Lógica de salida
    output_decod: process (current_state, DONE_M, DONE_A, color_in, dutys_in)
    begin
        -- Asignaciones por defecto
        SET_M <= '0';
        SET_A <= '0';

        -- Control de inputs_out
        case current_state is
            when MAN =>
                if DONE_M = '1' then
                    inputs_out <= (others => '0'); -- No copiar inputs_in
                else
                    inputs_out <= inputs_in; -- Copiar inputs_in
                end if;
            when AUT =>
                if DONE_A = '1' then
                    inputs_out <= (others => '0'); -- No copiar inputs_in
                else
                    inputs_out <= inputs_in; -- Copiar inputs_in
                end if;
            when others =>
                inputs_out <= inputs_in; -- Siempre copiar en otros estados
        end case;

        -- Asignaciones para los demás puertos
        case current_state is
            when REP =>
                mode  <= "00"; -- Estado REP
                color <= "11"; -- Color por defecto
                dutys <= (others => '1'); -- Valor por defecto (todos 1)
                duty  <= "0000"; -- Valor por defecto
            when MAN =>
                mode  <= "01"; -- Estado MAN
                color <= color_in; -- Asignar el color recibido
                dutys <= dutys_in; -- Asignar el duty recibido
                -- Activar SET_M solo si DONE_M es '0'
                if DONE_M = '0' then
                    SET_M <= '1';
                else
                    SET_M <= '0'; -- Desactivar si DONE_M = '1'
                end if;
                -- Calcular el duty específico para el color
                case color_in is
                    when "00" => duty <= dutys_in(3 downto 0);
                    when "01" => duty <= dutys_in(7 downto 4);
                    when "10" => duty <= dutys_in(11 downto 8); -- Selección directa de 4 bits
                    when others => duty <= "0000"; -- Default
                end case;
            when AUT =>
                mode  <= "10"; -- Estado AUT
                color <= "11"; -- Color por defecto
                dutys <= (others => '1'); -- Valor por defecto (todos 1)
                duty  <= "0000"; -- Valor por defecto
                -- Activar SET_A solo si DONE_A es '0'
                if DONE_A = '0' then
                    SET_A <= '1';
                else
                    SET_A <= '0'; -- Desactivar si DONE_A = '1'
                end if;
            when others =>
                mode  <= "00"; -- Default a REP
                color <= "11"; -- Color por defecto
                dutys <= (others => '1'); -- Valor por defecto (todos 1)
                duty  <= "0000"; -- Valor por defecto
        end case;
    end process;

end Behavioral;

