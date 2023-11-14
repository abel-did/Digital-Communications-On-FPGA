library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity uart_tx is
  generic (
    f_clk       : real     := 100.0E6;
    f_baud      : real     := 9600.0;
    N           : positive := 8;
    parity_bit  : boolean := true;       -- parity bit
    parity_odd  : boolean := true;       -- odd parity bit
    stop_bit_1  : boolean := true
  );
  port (
    clk    : in  std_logic;
    resetn : in  std_logic;
    start  : in  std_logic;
    data   : in  std_logic_vector (N-1 downto 0);
    ready  : out std_logic;
    tx     : out std_logic    
  );
end entity;

architecture rtl of uart_tx is
  type state is (idle, startbit,databit,stopbit,stopbit2,parbit);
  signal current_state : state;
  signal next_state    : state;
  
  constant x  : natural := integer(round(f_clk/f_baud)); 
  
  signal reg   : std_logic_vector (data'length downto 0);
  signal tempo : natural range 0 to x-1;
  
  signal end_tempo : std_logic;
  signal end_data  : std_logic;
  signal cmd_reg   : std_logic_vector(1 downto 0);
  signal cmd_tx    : std_logic_vector(1 downto 0);
  signal cmd_tempo : std_logic;
  signal reg_par   : std_logic;
  
begin
  end_tempo <= '0' when tempo < x-1 
          else '1';
          
  end_data <= '1' when unsigned(reg(reg'high downto reg'low+2))=0 --and reg(reg'low+1)='1'
         else '0';  
        
  process(clk,resetn) is
  begin
    if resetn = '0' then
      current_state <= idle;
      reg     <= (others => '0');
      tempo   <= 0;
      tx      <= '1';
      reg_par <= '0';
    elsif rising_edge(clk) then
      --state register
      current_state <= next_state;
      
      -- tx
      case cmd_tx is
      when "00" =>
        tx <= '0';
      when "01" =>
        tx <= '1';
      when "11" =>
        if parity_odd then 
          tx <= not  reg_par; 
        else 
          tx <= reg_par;  
        end if;
      when others =>
        tx <= reg(reg'low);
      end case;
      
       -- data register
      case cmd_reg is
      when "00" =>
        reg <= '1'&data;
      when "01" =>
        reg <= '0'&reg(reg'high downto reg'low+1);
      when others =>
        null;
      end case;   
      
       -- parity register
      case cmd_reg is
      when "00" =>
        reg_par <= '0';
      when "01" =>
        reg_par <=  reg_par xor reg(reg'low);
      when others =>
        null;
      end case; 
      
      -- timer
      if cmd_tempo = '1' then 
        tempo <= 0;
      else 
        tempo <= tempo+1;
      end if;  
      
    end if;
  end process;   
        
   process(current_state, start, end_tempo, end_data) is
   begin
     ready      <= '0';
     cmd_tx     <= "01";
     cmd_reg    <= "10";
     cmd_tempo  <= end_tempo;
     next_state <= current_state;
     
     case current_state is
     when idle =>
       if start = '1' then 
         next_state <= startbit;
         cmd_reg    <= "00";
       end if;
       cmd_tempo <= '1';
       ready     <= '1';
       
     when startbit =>
       if end_tempo = '1' then
         next_state <= databit;
       end if;
       cmd_tx    <= "00";
 
     when databit =>
       if end_tempo = '1' then
         if end_data = '1' then
           if parity_bit then
             next_state <= parbit;
           elsif stop_bit_1 then 
             next_state <= stopbit;
           else 
             next_state <= stopbit2;  
           end if;  
         end if;
         cmd_reg   <= "01";
       end if;
       cmd_tx    <= "10";
     
     
     when parbit =>
       cmd_tx <= "11";
       if end_tempo = '1' then
         if stop_bit_1 then 
           next_state <= stopbit;
         else 
           next_state <= stopbit2;  
        end if;
       end if;   
        
        
     when stopbit2 => 
       if end_tempo = '1' then
         next_state <= stopbit;
       end if;
         
     when stopbit =>
       if end_tempo = '1' then
         ready     <= '1';
         if start = '1' then
           next_state <= startbit;
           cmd_reg   <= "00";
         else
           next_state <= idle;
         end if;         
       end if;
       cmd_tx  <= "01"; 
       
     end case;
   end process;     
                    
end architecture;