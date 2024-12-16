library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity AUTO is
    Port (
        clk : in std_logic;       
        inputs : in std_logic_vector(3 downto 0); 
        SETA: in std_logic;
        salida_vector : out std_logic_vector(11 downto 0) 
    );
end AUTO;

architecture Behavioral of AUTO is
    -- Definición de los estados
    type state_type is (REPOSO, AUTO1, AUTO2);
    signal current_state : state_type :=REPOSO;
    signal next_state: state_type;
    -- Señales para generar valores aleatorios
    signal random_value_auto1 : std_logic_vector(11 downto 0) := "100010111001";
    signal random_value_auto2 : std_logic_vector(11 downto 0) := "001111001011";

    -- Señal para almacenar el último valor de salida
    signal last_value : std_logic_vector(11 downto 0) := (others => '0');
begin

-- Registro de estados
  ST_REG : process(SETA, clk)
  begin
    if SETA = '0' THEN
      current_state <= REPOSO;
    elsif rising_edge(clk) then
      current_state <= next_state;
    end if;
  end process;

    -- Proceso para la transición entre estados
    state_transition : process(current_state, inputs)
    begin
        case current_state is
            when REPOSO =>
                if inputs = "0100" then
                    next_state <= AUTO1;
                else
                    next_state <= REPOSO;
                end if;

            when AUTO1 =>
                if inputs = "0100" then
                    next_state <= AUTO2;
                elsif inputs = "1000" then
                    next_state <= REPOSO;
                else
                    next_state <= AUTO1;
                end if;

            when AUTO2 =>
                if inputs = "0100" then
                    next_state <= REPOSO;
                elsif inputs = "1000" then
                    next_state <= AUTO1;
                else
                    next_state <= AUTO2;
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

                when AUTO1 =>
                    salida_vector <= random_value_auto1; -- Generar valores aleatorios
                    last_value <= random_value_auto1; -- Guardar el último valor

                when AUTO2 =>
                    salida_vector <= random_value_auto2; -- Generar valores aleatorios
                    last_value <= random_value_auto2; -- Guardar el último valor

               when others =>
                    salida_vector <= (others => '0'); -- Default
            end case;
        end if;
    end process;

   -- Generador aleatorio para AUTO1
    random_generator_auto1 : process(clk)
    begin
        if rising_edge(clk) then
            if current_state = AUTO1 then
                random_value_auto1(11) <= random_value_auto1(10) xor random_value_auto1(7) xor random_value_auto1(4) xor random_value_auto1(0);
                random_value_auto1(10) <= random_value_auto1(4) xor random_value_auto1(6) xor random_value_auto1(3) xor random_value_auto1(11);
                random_value_auto1(9)  <= random_value_auto1(1) xor random_value_auto1(5) xor random_value_auto1(2) xor random_value_auto1(10);
                random_value_auto1(8)  <= random_value_auto1(7) xor random_value_auto1(4) xor random_value_auto1(1) xor random_value_auto1(9);
                random_value_auto1(7)  <= random_value_auto1(11) xor random_value_auto1(3) xor random_value_auto1(0) xor random_value_auto1(8);
                random_value_auto1(6)  <= random_value_auto1(0) xor random_value_auto1(2) xor random_value_auto1(11) xor random_value_auto1(7);
                random_value_auto1(5)  <= random_value_auto1(2) xor random_value_auto1(1) xor random_value_auto1(10) xor random_value_auto1(6);
                random_value_auto1(4)  <= random_value_auto1(6) xor random_value_auto1(0) xor random_value_auto1(9) xor random_value_auto1(5);
                random_value_auto1(3)  <= random_value_auto1(1) xor random_value_auto1(11) xor random_value_auto1(8) xor random_value_auto1(4);
                random_value_auto1(2)  <= random_value_auto1(9) xor random_value_auto1(10) xor random_value_auto1(7) xor random_value_auto1(3);
                random_value_auto1(1)  <= random_value_auto1(10) xor random_value_auto1(9) xor random_value_auto1(6) xor random_value_auto1(2);
                random_value_auto1(0)  <= random_value_auto1(11) xor random_value_auto1(8) xor random_value_auto1(5) xor random_value_auto1(1);
            end if;
        end if;
    end process;

    -- Generador aleatorio para AUTO2
    random_generator_auto2 : process(clk)
    begin
        if rising_edge(clk) then
            if current_state = AUTO2 then
                random_value_auto2(11) <= random_value_auto2(0) xor random_value_auto2(8) xor random_value_auto2(5) xor random_value_auto2(0);
                random_value_auto2(10) <= random_value_auto2(6) xor random_value_auto2(7) xor random_value_auto2(4) xor random_value_auto2(11);
                random_value_auto2(9)  <= random_value_auto2(2) xor random_value_auto2(6) xor random_value_auto2(3) xor random_value_auto2(10);
                random_value_auto2(8)  <= random_value_auto2(10) xor random_value_auto2(5) xor random_value_auto2(2) xor random_value_auto2(9);
                random_value_auto2(7)  <= random_value_auto2(1) xor random_value_auto2(4) xor random_value_auto2(1) xor random_value_auto2(8);
                random_value_auto2(6)  <= random_value_auto2(5) xor random_value_auto2(3) xor random_value_auto2(0) xor random_value_auto2(7);
                random_value_auto2(5)  <= random_value_auto2(3) xor random_value_auto2(2) xor random_value_auto2(11) xor random_value_auto2(6);
                random_value_auto2(4)  <= random_value_auto2(11) xor random_value_auto2(1) xor random_value_auto2(10) xor random_value_auto2(5);
                random_value_auto2(3)  <= random_value_auto2(9) xor random_value_auto2(0) xor random_value_auto2(9) xor random_value_auto2(4);
                random_value_auto2(2)  <= random_value_auto2(3) xor random_value_auto2(11) xor random_value_auto2(8) xor random_value_auto2(3);
                random_value_auto2(1)  <= random_value_auto2(8) xor random_value_auto2(10) xor random_value_auto2(7) xor random_value_auto2(2);
                random_value_auto2(0)  <= random_value_auto2(1) xor random_value_auto2(9) xor random_value_auto2(6) xor random_value_auto2(1);
            end if;
        end if;
    end process;
end Behavioral;
