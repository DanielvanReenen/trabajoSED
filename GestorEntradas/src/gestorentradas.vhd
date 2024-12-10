library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity GestorEntradas is
    generic (
        N : integer := 5 -- Número de señales de entrada/salida
    );
    port (
        INPUTS  : in  std_logic_vector(N-1 downto 0); -- Entradas
        CLK_IN  : in  std_logic;                     -- Reloj de entrada
        OUTPUTS : out std_logic_vector(N-1 downto 0); -- Salidas
        CLK_OUT : out std_logic                      -- Reloj de salida
    );
end GestorEntradas;

architecture Behavioral of GestorEntradas is
    signal aux : std_logic_vector(N-1 downto 0) := (others => '0');

    COMPONENT SYNCHRNZR
        generic (
            N : integer := 5
        );
        port ( 
            CLK       : in  std_logic;
            ASYNC_IN  : in  std_logic_vector(N-1 downto 0);
            SYNC_OUT  : out std_logic_vector(N-1 downto 0)
        );
    END COMPONENT;
    
    COMPONENT EDGEDTCTR
        generic (
            N : integer := 5
        );
        port ( 
            CLK      : in  std_logic;
            SYNC_IN  : in  std_logic_vector(N-1 downto 0);
            EDGE     : out std_logic_vector(N-1 downto 0)
        );
    END COMPONENT;
    
begin
    -- Sincronizador
    Inst_SYNCHRNZR: SYNCHRNZR
        generic map (
            N => N
        )
        port map (
            ASYNC_IN => INPUTS, 
            SYNC_OUT => aux,
            CLK => CLK_IN
        );
    
    -- Detector de flancos
    Inst_EDGEDTCTR: EDGEDTCTR
        generic map (
            N => N
        )
        port map (
            SYNC_IN => aux, 
            EDGE => OUTPUTS,
            CLK => CLK_IN -- Conectado al mismo reloj
        );

    -- Asignar el reloj de salida
    CLK_OUT <= CLK_IN; -- Copiar el reloj de entrada
    
    
end Behavioral;

