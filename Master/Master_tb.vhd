library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Master_tb is
end Master_tb;

architecture Behavioral of Master_tb is
    -- Declaración de señales para conectar con el DUT
    signal inputs_in  : std_logic_vector(3 downto 0) := "0000";
    signal inputs_out : std_logic_vector(3 downto 0);
    signal clk        : std_logic := '0';
    signal reset      : std_logic := '0';
    signal color_in   : std_logic_vector(1 downto 0) := "00";
    signal dutys_in   : std_logic_vector(11 downto 0) := (others => '0');
    signal DONE_M     : std_logic := '0';
    signal DONE_A     : std_logic := '0';

    signal mode       : std_logic_vector(1 downto 0);
    signal color      : std_logic_vector(1 downto 0);
    signal dutys      : std_logic_vector(11 downto 0);
    signal duty       : std_logic_vector(3 downto 0);
    signal SET_M      : std_logic;
    signal SET_A      : std_logic;

    -- DUT (Device Under Test)
    component Master
        port (
            inputs_in  : in  std_logic_vector(3 downto 0);
            inputs_out : out std_logic_vector(3 downto 0);
            clk        : in  std_logic;
            reset      : in  std_logic;
            color_in   : in  std_logic_vector(1 downto 0);
            dutys_in   : in  std_logic_vector(11 downto 0);
            DONE_M     : in  std_logic;
            DONE_A     : in  std_logic;

            mode       : out std_logic_vector(1 downto 0);
            color      : out std_logic_vector(1 downto 0);
            dutys      : out std_logic_vector(11 downto 0);
            duty       : out std_logic_vector(3 downto 0);
            SET_M      : out std_logic;
            SET_A      : out std_logic
        );
    end component;

begin
    -- Instancia del DUT
    DUT: Master
        port map (
            inputs_in  => inputs_in,
            inputs_out => inputs_out,
            clk        => clk,
            reset      => reset,
            color_in   => color_in,
            dutys_in   => dutys_in,
            DONE_M     => DONE_M,
            DONE_A     => DONE_A,
            mode       => mode,
            color      => color,
            dutys      => dutys,
            duty       => duty,
            SET_M      => SET_M,
            SET_A      => SET_A
        );

    -- Generador de reloj
    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for 10 ns;
            clk <= '1';
            wait for 10 ns;
        end loop;
    end process;

    -- Estímulos
    stimulus_process: process
    begin
        -- Reset inicial
        reset <= '1'; -- Mantener reset activado
        wait for 20 ns;
        reset <= '0'; -- Liberar reset
        wait for 20 ns;
        reset <= '1'; -- Desactivar reset
        wait for 40 ns;

        -- Caso 1: Transición a estado MAN
        inputs_in <= "0100"; -- Activar inputs_in(2) para avanzar a MAN
        wait for 40 ns;

        -- Caso 2: Transición a estado AUT
        inputs_in <= "0100"; -- Activar inputs_in(2) para avanzar a AUT
        wait for 40 ns;

        -- Caso 3: Intentar retroceder a REP desde AUT
        inputs_in <= "1000"; -- Activar inputs_in(3) para retroceder a REP
        wait for 40 ns;

        -- Caso 4: Transición de REP a AUT directamente
        inputs_in <= "1000"; -- Activar inputs_in(3) para avanzar a AUT
        wait for 40 ns;
        inputs_in <= "0000";
        
        -- Verificar funcionalidad de DONE_M
        DONE_M <= '1'; -- FSM Manual completa su tarea
        wait for 40 ns;

        -- Verificar funcionalidad de DONE_A
        DONE_A <= '1'; -- FSM Automático completa su tarea
        wait for 40 ns;

        -- Finalizar simulación
        wait;
    end process;

end Behavioral;
