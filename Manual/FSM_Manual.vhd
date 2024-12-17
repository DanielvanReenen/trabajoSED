library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSM_Manual is
  port(
    inputs     : in  STD_LOGIC_VECTOR(3 DOWNTO 0); -- Control inputs
    SETM       : in  STD_LOGIC;                   -- Reset/control signal
    clk        : in  STD_LOGIC;                   -- Clock
    DUTYS      : out STD_LOGIC_VECTOR(11 DOWNTO 0); -- Duty cycles for RGB
    COLOR      : out STD_LOGIC_VECTOR(1 DOWNTO 0)  -- Current color state
  );
end FSM_Manual;

architecture Behavioral of FSM_Manual is
  -- Tipo de estado
  type STATE_M is (ROJO, VERDE, AZUL);
  signal cur_state, nxt_state : STATE_M := ROJO;

  -- Señales internas para los duty cycles
  signal duty_rojo  : unsigned(3 downto 0) := "0000";
  signal duty_verde : unsigned(3 downto 0) := "0000";
  signal duty_azul  : unsigned(3 downto 0) := "0000";

begin

  -- Registro de estados
  ST_REG: process(clk, SETM)
  begin
    if SETM = '0' then
      cur_state <= AZUL; -- Reset: volver al estado ROJO
    elsif rising_edge(clk) then
      cur_state <= nxt_state;
    end if;
  end process;

  -- Lógica de transición de estados
  NEXT_STATE: process(inputs, cur_state)
  begin
    nxt_state <= cur_state; -- Mantener el estado por defecto

    case cur_state is
      when ROJO =>
        if rising_edge(inputs(2)) then
          nxt_state <= VERDE; -- Avanzar al estado VERDE
        elsif rising_edge(inputs(3)) then
          nxt_state <= AZUL; -- Retroceder al estado AZUL
        end if;

      when VERDE =>
        if rising_edge(inputs(2)) then
          nxt_state <= AZUL; -- Avanzar al estado AZUL
        elsif rising_edge(inputs(3)) then
          nxt_state <= ROJO; -- Retroceder al estado ROJO
        end if;

      when AZUL =>
        if rising_edge(inputs(2)) then
          nxt_state <= ROJO; -- Avanzar al estado ROJO
        elsif rising_edge(inputs(3)) then
          nxt_state <= VERDE; -- Retroceder al estado VERDE
        end if;

    end case;
  end process;

  -- Lógica de salida y ajuste del DUTY
  STATE_ACTION: process(inputs, cur_state)
  begin
    -- Asignaciones por defecto
    DUTYS <= (others => '0');
    COLOR <= "11"; -- Estado inválido por defecto

    case cur_state is
      when ROJO =>
        COLOR <= "10"; -- Color ROJO
        if inputs(1) = '1' and duty_rojo < "1111" then
          duty_rojo <= duty_rojo + 1; -- Incrementar duty
        elsif inputs(0) = '1' and duty_rojo > "0000" then
          duty_rojo <= duty_rojo - 1; -- Decrementar duty
        end if;


      when VERDE =>
        COLOR <= "01"; -- Color VERDE
        if inputs(1) = '1' and duty_verde < "1111" then
          duty_verde <= duty_verde + 1; -- Incrementar duty
        elsif inputs(0) = '1' and duty_verde > "0000" then
          duty_verde <= duty_verde - 1; -- Decrementar duty
        end if;
  

      when AZUL =>
        COLOR <= "00"; -- Color AZUL
        if inputs(1) = '1' and duty_azul < "1111" then
          duty_azul <= duty_azul + 1; -- Incrementar duty
        elsif inputs(0) = '1' and duty_azul > "0000" then
          duty_azul <= duty_azul - 1; -- Decrementar duty
        end if;
     

      when others =>
        COLOR <= "11"; -- Estado inválido
    end case;
    
       DUTYS(3 downto 0) <= std_logic_vector(duty_azul);
       DUTYS(7 downto 4) <= std_logic_vector(duty_verde);
       DUTYS(11 downto 8) <= std_logic_vector(duty_rojo);
  end process;

end Behavioral;
