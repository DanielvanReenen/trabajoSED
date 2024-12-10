LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY top IS
    PORT (
        button : IN std_logic;
        clk : IN std_logic;
        reset : IN std_logic;  -- Señal de RESET
        LIGHT: OUT std_logic_vector (3 downto 0)
    );
END top;

ARCHITECTURE behavior OF top IS

    COMPONENT SYNCHRNZR
    PORT ( 
        CLK : IN std_logic;
        ASYNC_IN : IN std_logic;
        SYNC_OUT : OUT std_logic
    );
    END COMPONENT;
    
    COMPONENT EDGEDTCTR
    PORT ( 
        CLK : IN std_logic;
        SYNC_IN : IN std_logic;
        EDGE : OUT std_logic
    );
    END COMPONENT;
    
    COMPONENT fsm
    PORT(
    RESET: IN std_logic;
    CLK: IN std_logic;
    PUSHBUTTON: IN std_logic;
    LIGHT: OUT std_logic_vector (3 downto 0)
    );
    END COMPONENT;
        
    signal aux1: std_logic;
    signal aux2: std_logic;
    
    BEGIN
    Inst_SYNCHRNZR: SYNCHRNZR
    PORT MAP (
        ASYNC_IN => button, 
        SYNC_OUT => aux1,
        CLK => clk
    );
    
    Inst_EDGEDTCTR: EDGEDTCTR
    PORT MAP (
        SYNC_IN => aux1, 
        EDGE => aux2,
        CLK => clk
    );
    
    Inst_fsm: fsm
    PORT MAP(
    RESET=> reset,
    CLK=>clk,
    PUSHBUTTON=>aux2,
    LIGHT=>LIGHT
    );

END behavior;
