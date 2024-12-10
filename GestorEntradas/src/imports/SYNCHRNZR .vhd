library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SYNCHRNZR is
    generic (
        N : integer := 5 -- Número de señales de entrada/salida
    );
    port (
        CLK       : in  std_logic;                      -- Señal de reloj
        ASYNC_IN  : in  std_logic_vector(N-1 downto 0); -- Vector de entradas asíncronas
        SYNC_OUT  : out std_logic_vector(N-1 downto 0)  -- Vector de salidas sincronizadas
    );
end SYNCHRNZR;

architecture BEHAVIORAL of SYNCHRNZR is
    -- Registro de sincronización para cada señal, en forma de matriz
    signal sreg : std_logic_vector(2*N-1 downto 0); -- Registro de 2 etapas por señal
begin
    process (CLK)
    begin
        if rising_edge(CLK) then
            -- Actualizar las salidas sincronizadas con el segundo bit del registro
            SYNC_OUT <= sreg(2*N-1 downto N);

            -- Desplazar cada señal hacia los registros de sincronización
            sreg(2*N-1 downto N) <= sreg(N-1 downto 0); -- Segunda etapa
            sreg(N-1 downto 0) <= ASYNC_IN;             -- Primera etapa
        end if;
    end process;
end BEHAVIORAL;
