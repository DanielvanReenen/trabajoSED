library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm is
port (
RESET : in std_logic;
CLK : in std_logic;
PUSHBUTTON : in std_logic;
LIGHT : out std_logic_vector(0 TO 2)
);
end fsm;
architecture behavioral of fsm is
type STATES is (R, G, B);
signal current_state: STATES := R;
signal next_state: STATES;
begin

state_register: process (RESET, CLK)
begin
    if RESET = '0' then
        current_state <= R;  -- Restablecer al estado inicial
    elsif rising_edge(CLK) then
        current_state <= next_state;  -- Actualizar al siguiente estado
    end if;
end process;

nextstate_decod: process (PUSHBUTTON, current_state)
begin
next_state <= current_state;
case current_state is
when R =>
if PUSHBUTTON = '1' then
next_state <= G;
end if;
when G =>
if PUSHBUTTON = '1' then
next_state <= B;
end if;
when B =>
if PUSHBUTTON = '1' then
next_state <= G;
end if;
end case;
end process;
output_decod: process (current_state)
begin
LIGHT <= (OTHERS => '0');
case current_state is
when R =>
LIGHT(0) <= '1';
when G =>
LIGHT(1) <= '1';
when B =>
LIGHT(2) <= '1';
LIGHT <= (OTHERS => '0');
end case;
end process;
end behavioral;
