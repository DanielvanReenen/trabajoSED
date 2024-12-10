library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity EDGEDTCTR is
    generic (
        N : integer := 1 -- Número de señales a procesar (por defecto, 1)
    );
    port (
        CLK      : in  std_logic;                      -- Señal de reloj
        SYNC_IN  : in  std_logic_vector(N-1 downto 0); -- Vector de entradas sincronizadas
        EDGE     : out std_logic_vector(N-1 downto 0)  -- Vector de salidas de detección de flanco
    );
end EDGEDTCTR;

architecture BEHAVIORAL of EDGEDTCTR is
    -- Registro de 3 etapas para cada entrada
    signal sreg : std_logic_vector(3*N-1 downto 0); -- Vector de registros
begin
    -- Proceso de actualización de los registros
    process (CLK)
    begin
        if rising_edge(CLK) then
            -- Desplazar las señales sincronizadas en los registros
            sreg(3*N-1 downto 2*N) <= sreg(2*N-1 downto N); -- Etapa 2 -> Etapa 3
            sreg(2*N-1 downto N) <= sreg(N-1 downto 0);      -- Etapa 1 -> Etapa 2
            sreg(N-1 downto 0) <= SYNC_IN;                  -- Entrada -> Etapa 1
        end if;
    end process;

    -- Detección de flanco ascendente
    gen_detect: for i in 0 to N-1 generate
        EDGE(i) <= '1' when sreg(2*N+i) = '1' and sreg(N+i) = '0' else '0';
    end generate;
    
end BEHAVIORAL;
