library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity uart_rx is
  generic (
    f_clk       : real     := 100.0E6;
    f_baud      : real     := 9600.0;
    N           : positive := 8;
    parity_bit  : boolean := true;       -- parity bit
    parity_odd  : boolean := true;       -- odd parity bit
    stop_bit_1  : boolean := true
  );
  port (
    clk          : in  std_logic;
    resetn       : in  std_logic;
    rx           : in  std_logic;
    data         : out std_logic_vector (N-1 downto 0);
    ready        : out std_logic;
    update_rx    : out std_logic;
    error_stop   : out std_logic;
    error_parity : out std_logic   
  );
end entity;

architecture rtl of uart_rx is
  type state is (idle, startbit, databit, parbit, stopbit, stopbit2);
  signal current_state : state;
  signal next_state    : state;
  
  constant x    : natural := integer(round(f_clk/f_baud)); 
  constant xmid : natural := integer(ceil(f_clk/f_baud/2.0));
  
  signal reg   : std_logic_vector (data'range);
  signal tempo : natural range 0 to x-1;
  
  signal end_tempo  : std_logic;
  signal x_comp     : natural range 0 to x-1;
  signal end_data   : std_logic;
  signal cmd_reg    : std_logic_vector(1 downto 0);
  signal cmd_tempo  : std_logic;
  signal cmd_start  : std_logic;
  signal reg_rx     : std_logic_vector(1 downto 0);
  signal reg_par    : std_logic;
  signal cmd_stop   : std_logic_vector(1 downto 0);
  signal cmd_par    : std_logic_vector(1 downto 0);
  
  
begin
  data <= reg(data'range);
  
  end_tempo <= '0' when tempo < x_comp 
          else '1';
		  
  x_comp <= x-1 when cmd_start = '0'
       else xmid-1 ;
		  
  end_data <= not reg(reg'low);  
        
  process(clk,resetn) is
  begin
    if resetn = '0' then
      current_state <= idle;
      reg           <= (others => '0');
      reg_rx        <= (others => '1');
      tempo         <= 0;
	    error_stop    <= '0';
	    error_parity  <= '0';
      reg_par <= '0';
	    
    elsif rising_edge(clk) then
      --state register
      current_state <= next_state;
	  
      -- rx register
      reg_rx <=rx&reg_rx(1);	
	  
      -- data register
      case cmd_reg is
      when "00" =>
        reg <= (others => '1');
      when "01" =>
        reg <= reg_rx(0)&reg(reg'high downto reg'low+1);
      when others =>
        null;
      end case;  
      
      -- parity register
      case cmd_reg is
      when "00" =>
        reg_par <= '0';
      when "01"|"11" =>
        reg_par <= reg_rx(0) xor reg_par;
      when others =>
        null;
      end case; 
	  
      -- stop error register  
      case cmd_stop is
      when "00" =>
        error_stop <= '0';
      when "01" =>
        error_stop <= '1';
      when others =>
        null;
      end case; 
        
    -- parity error register  
      case cmd_par is
      when "00" =>
        error_parity <= '0';
      when "01" =>
       if parity_odd then
         error_parity <= not reg_par;
       else
         error_parity <= reg_par;
       end if;
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
        
  process(current_state, reg_rx, end_tempo, end_data) is
  begin
    ready      <= '0';
    cmd_reg    <= "10";
    cmd_tempo  <= end_tempo;
    cmd_start  <= '0';
    cmd_stop   <= "10";
    cmd_par    <= "10";
    next_state <= current_state;
    update_rx  <= '0';
     
    case current_state is
    when idle =>
      if reg_rx(0) = '0' then 
        next_state <= startbit;
        cmd_stop   <= "00";		-- mise a 0 de l'erreur de stop
        cmd_par    <= "00";   -- mise a 0 de l'erreur de parite
        
      end if;
      cmd_tempo <= '1';  -- mise à 0 de ctr_tempo
      ready     <= '1';
      
    when startbit =>
      if end_tempo = '1' then
        if reg_rx(0) = '0' then 
          next_state <= databit;
        else
          next_state <= idle;
        end if;	
        cmd_reg    <= "01"; -- reg : shift
      else 
        cmd_reg    <= "00";	-- reg : mise à 1...1  
      end if;
      cmd_start  <= '1';
      ready      <= '1';
    	 
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
        cmd_reg   <= "01";  -- reg : shift
      end if;
    
    when parbit =>
      if end_tempo = '1' then
        if stop_bit_1 then
          next_state <= stopbit;
        else
          next_state <= stopbit2;
        end if;            
        cmd_reg   <= "11";  -- parity 
      end if;
      
    when stopbit2 =>
      if end_tempo = '1' then
        next_state <= stopbit;
        if reg_rx(0)= '0' then
          cmd_stop    <= "01";  -- stop error
		   end if;		
      end if;  
      
    when stopbit =>
      if end_tempo = '1' then
        next_state <= idle;  
        cmd_par    <= "01";
        update_rx  <= '1';
        if reg_rx(0)= '0' then
          cmd_stop    <= "01";  -- stop error
		    end if;		
      end if;  
    end case;
  end process;                        
end architecture;