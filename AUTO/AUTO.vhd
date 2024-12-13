library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity AUTO is
    Port (
        clk : in std_logic;
        reset : in std_logic;
        btn_avanzar : in std_logic;
        btn_retroceder : in std_logic;
        salida_vector : out std_logic_vector(11 downto 0); 
        flag : out std_logic 
    );
end AUTO;

architecture Behavioral of AUTO is
    -- Definición de los estados
    type state_type is (REPOSO, AUTO1, AUTO2, SALIR);
    signal current_state, next_state : state_type;

    -- Señales para generar valores aleatorios
    signal random_value_auto1 : std_logic_vector(11 downto 0) := "100010111001";
    signal random_value_auto2 : std_logic_vector(11 downto 0) := "001111001011";

    -- Señal para almacenar el último valor de salida
    signal last_value : std_logic_vector(11 downto 0) := (others => '0');
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
    state_transition : process(current_state, btn_avanzar, btn_retroceder)
    begin
        case current_state is
            when REPOSO =>
                if btn_avanzar = '1' then
                    next_state <= AUTO1;
                else
                    next_state <= REPOSO;
                end if;

            when AUTO1 =>
                if btn_avanzar = '1' then
                    next_state <= AUTO2;
                elsif btn_retroceder = '1' then
                    next_state <= REPOSO;
                else
                    next_state <= AUTO1;
                end if;

            when AUTO2 =>
                if btn_avanzar = '1' then
                    next_state <= SALIR;
                elsif btn_retroceder = '1' then
                    next_state <= AUTO1;
                else
                    next_state <= AUTO2;
                end if;

            when SALIR =>
                next_state <= SALIR; -- Mantenerse en SALIR indefinidamente

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
                    salida_vector <= last_value; 
                    flag <= '0'; 

                when AUTO1 =>
                    salida_vector <= random_value_auto1; 
                    flag <= '0'; 
                    last_value <= random_value_auto1; 

                when AUTO2 =>
                    salida_vector <= random_value_auto2; 
                    flag <= '0'; 
                    last_value <= random_value_auto2; 

                when SALIR =>
                    salida_vector <= last_value; 
                    flag <= '1'; 

                when others =>
                    salida_vector <= (others => '0'); 
                    flag <= '0'; 
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
