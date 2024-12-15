----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.12.2024 12:40:26
-- Design Name: 
-- Module Name: FSM_Manual - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity FSM_Manual is
  port(
    inputs     : in STD_LOGIC_VECTOR(3 DOWNTO 0);
    SETM       : in STD_LOGIC;
    clk        : in STD_LOGIC;
    DONE       : out STD_LOGIC := '0';
    DUTYS      : out STD_LOGIC_VECTOR(11 DOWNTO 0) := "000000000000";
    COLOR      : out STD_LOGIC_VECTOR(1 DOWNTO 0) := "11"
    );
end FSM_Manual;

architecture Behavioral of FSM_Manual is
-- Para la m�quina de estados
type STATE_M is (REPOSO, ROJO, VERDE, AZUL, SALIR);
signal cur_state : STATE_M := REPOSO;
signal nxt_state : STATE_M;

-- Para fragmentar los duty cycles de cada color
signal duty_original : std_logic_vector(11 downto 0);
signal duty_rojo : unsigned(3 downto 0) := "0000";
signal duty_verde: unsigned(3 downto 0) := "0000";
signal duty_azul : unsigned(3 downto 0) := "0000";

-- Registro de estados
  begin
    ST_REG : process(SETM, clk)   
    begin
    if SETM = '0' THEN
      cur_state <= REPOSO;
    elsif rising_edge(clk) then
      cur_state <= nxt_state;
    end if;
    end process;
    
-- Avance de estados    
    NEXT_STATE : process(inputs, cur_state)
    begin
      nxt_state <= cur_state;
      case cur_state is
        when REPOSO =>
          if inputs = "0100" then
            nxt_state <= ROJO;
          elsif inputs = "1000" then
            nxt_state <= SALIR;
          end if;
          
        when ROJO =>
          if inputs = "0100" then
            nxt_state <= VERDE;
          elsif inputs = "1000" then
            nxt_state <= REPOSO;
          end if;
          
        when VERDE =>
          if inputs = "0100" then
            nxt_state <= AZUL;
          elsif inputs = "1000" then
            nxt_state <= ROJO;
          end if;
        
        when AZUL =>
          if inputs = "0100" then
            nxt_state <= SALIR;
          elsif inputs = "1000" then
            nxt_state <= VERDE;
          end if;
        
        when SALIR =>
          if inputs = "0100" then
            nxt_state <= REPOSO;
          elsif inputs = "1000" then
            nxt_state <= AZUL;
          end if;
          
        when others =>
            report "ERROR: Invalid state transition in NEXT_STATE process.";
            nxt_state <= REPOSO; 
            
      end case;  
    end process;
    
-- Acci�n realizada en cada estado
    STATE_ACTION : process(inputs, cur_state)
    
    begin
      case cur_state is
        when REPOSO =>
            DONE <= '0';
            COLOR <= "11";
          
        when ROJO =>
            DONE <= '0';
            if inputs = "0001" and duty_rojo /= "0000" then
              duty_rojo <= duty_rojo - 1;
            elsif inputs = "0010" and duty_rojo /= "1111" then
              duty_rojo <= duty_rojo + 1;
            end if;
            duty_original(11 downto 8) <= STD_LOGIC_VECTOR(duty_rojo);
            COLOR <= "10";
              
        when VERDE =>
            DONE <= '0';
            if inputs = "0001" and duty_verde /= "0000" then
              duty_verde <= duty_verde - 1;
            elsif inputs = "0010" and duty_verde /= "1111" then
              duty_verde <= duty_verde + 1;
            end if;
            duty_original(7 downto 4) <= STD_LOGIC_VECTOR(duty_verde);
            COLOR <= "01";
          
        when AZUL =>
            DONE <= '0';
            if inputs = "0001" and duty_azul /= "0000" then
              duty_azul <= duty_azul - 1;
            elsif inputs = "0010" and duty_azul /= "1111" then
              duty_azul <= duty_azul + 1;
            end if;
            duty_original(3 downto 0) <= STD_LOGIC_VECTOR(duty_azul);
            COLOR <= "00";

        when SALIR =>
            DUTYS <= duty_original;
            DONE <= '1';
            COLOR <= "11";
      
      end case; 
    end process;
          
end Behavioral;
