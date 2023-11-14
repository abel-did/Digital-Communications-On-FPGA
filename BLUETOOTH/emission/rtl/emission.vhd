---------------------------------------
--  emission de 8 bits
---------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee. math_real.all;

entity emission is
  generic  (
    N_addr     : positive := 7;  
    f_clk      : real     := 100_000_000.0;
    uart_rate  : real     := 115_200.0;
    parity_bit : boolean  := false ;    
    parity_odd : boolean  := true  ;     
    stop_bit_1 : boolean  := true  ;
    message    : string   := "Bravo! La transmission est operationnelle. Verifiez CRC OK : 0x06 sur led, si 0x15, erreur de CRC.     "
  );
  port (
    clk         : in  std_logic;  
    btnc        : in  std_logic;  -- btnc
    btnu        : in  std_logic;  -- start transfer
    led         : out std_logic_vector(15 downto 0);
    -- BT2  
    rxd         : in  std_logic;
    txd         : out std_logic;
    rts         : in  std_logic;
    cts         : out std_logic;
    status      : in  std_logic;
    rst         : out std_logic	  
    ); 
end entity;

architecture rtl of emission is

  signal resetn        : std_logic;  -- inverse de btnc
  signal start_e       : std_logic;  -- detection de front montant sur btnu
  signal ready         : std_logic;  -- systeme pret
  signal old_btnu      : std_logic;  -- pour detection de front sur btnu
  
  -- uart
  signal start_tx      : std_logic;
  signal ready_tx      : std_logic;
  signal ready_rx      : std_logic;
  signal data_tx       : std_logic_vector(7 downto 0);
  signal data_rx       : std_logic_vector(7 downto 0);
  
 
  -- crc
  constant polynom     : std_logic_vector(7 downto 0) := X"07";
  signal reg_crc       : std_logic_vector(7 downto 0);
  signal cmd_crc       : std_logic_vector(1 downto 0);
  
  -- mémoire
  signal addr          : std_logic_vector(N_addr-1 downto 0);
  signal data_mem      : std_logic_vector(7 downto 0);
  
  -- Cptr Addr
  signal cmd_cptr_addr : std_logic_vector(1 downto 0);
  signal cptr_addr     : natural range 0 to 2**N_addr;
  signal end_addr      : std_logic;

  -- Multiplexor Data TX
  signal cmd_data_tx   : std_logic_vector(2 downto 0);

  -- Rising Edge Ready TX
  signal ready_tx_Q     : std_logic;
  signal front_ready_tx : std_logic;

  -- FSM
  type state is (idle, start_byte, data_byte0, data_byte1, crc_byte, stop_byte);
  signal current_state : state;
  signal next_state    : state;

begin

--------------------------------------------------------------------------
-- Operative Part
--------------------------------------------------------------------------

  -- Compteur Addr
  ----------------
  -- Set to 0       : cmd_cptr_addr : "00"
  -- Incrementation : cmd_cptr_addr : "01"
  -- Memorization   : cmd_cptr_addr : "10" | "11"

  end_addr <= '1' when cptr_addr = 2**N_addr-1  else  
              '0';

  process(clk, resetn)
  begin
    if resetn = '0' then
      cptr_addr <= 0;
    elsif rising_edge(clk) then
      case cmd_cptr_addr is
        when "00" => cptr_addr <= 0;
        when "01" => cptr_addr <= cptr_addr + 1;
        when others => cptr_addr <= cptr_addr;
      end case;
    end if;
  end process;

  addr <= std_logic_vector(to_unsigned(cptr_addr, addr'length));

  -- Multiplexor
  --------------
  -- Set to 0x02      : cmd_data_tx : "000"
  -- Set to data_mem  : cmd_data_tx : "001"
  -- Set to reg_crc   : cmd_data_tx : "010"
  -- Set to 0x04      : cmd_data_tx : "011"
  -- Set to 0x00      : others
  data_tx <=  x"02"     when cmd_data_tx = "000" else
              data_mem  when cmd_data_tx = "001" else
              reg_crc   when cmd_data_tx = "010" else
              x"04"	    when cmd_data_tx = "011" else
	            x"00";


  -- Rising Edge Ready TX
  process(clk,resetn)
  begin
    if resetn = '0' then
      ready_tx_Q <= '0';
    elsif rising_edge(clk) then
      ready_TX_Q <= ready_tx;
    end if;
  end process;

  front_ready_tx <= not ready_tx_Q and ready_tx;
  
--------------------------------------------------------------------------
--  Control Part
--------------------------------------------------------------------------

  -- Registre d'état
  process(resetn, clk) is
  begin
    if resetn = '0' then
      current_state <= idle;
    elsif rising_edge(clk) then
      current_state <= next_state;
    end if;
  end process;

  process(current_state, start_e, front_ready_tx, end_addr) is
    begin
      next_state    <= current_state;
      
      cmd_cptr_addr <= "00";              -- Set to 0
      cmd_data_tx   <= "111";             -- 0x00
      cmd_crc       <= "00";              -- Set to 0
      start_tx      <= '0';               -- Set to 0
      ready 	    <= '0';
      case current_state is
        
        when idle =>
		ready 	      <= '1';
	        cmd_data_tx   <= "111";         	-- 0x00
          if start_e = '1' then
            next_state  <= start_byte;
            start_tx    <= '1';           		-- Set to 1
	          cmd_data_tx <= "000";         	-- 0x02
          end if;

        when start_byte => 
	        cmd_data_tx   <= "000";         	-- 0x02
          if front_ready_tx = '1' then
            next_state  <= data_byte0;
            start_tx    <= '1';           		-- Set to 1
	          cmd_data_tx   <= "001";       	-- Set to data_mem
          end if;
        
        when data_byte0 =>
	        cmd_data_tx   <= "001";         	-- Set to data_mem
          if front_ready_tx = '0' then
            next_state  <= data_byte1;
            cmd_cptr_addr <= "01";     	  		-- Incrementation
            cmd_crc       <= "01";     	  		-- CRC Calc
	          cmd_data_tx   <= "001";       	-- Set to data_mem
          --else
            --cmd_cptr_addr <= "01";     	  	-- Incrementation
            --cmd_crc       <= "11";        		-- CRC memorrization
	          --cmd_data_tx   <= "001";       	-- Set to data_mem
          end if;
	  
        when data_byte1 =>
	        cmd_data_tx   <= "001";                               	-- Set to data_mem
          if front_ready_tx = '1' and end_addr = '0' then
            next_state    <= data_byte0;
	          cmd_cptr_addr <= "11";                              	-- Memorrization
            cmd_crc       <= "11";                              	-- memorrization
	          start_tx      <= '1';                               	-- Set to 1
	          cmd_data_tx   <= "001";                             	-- Set to data_mem
          elsif front_ready_tx = '1' and end_addr = '1' then
                next_state    <= crc_byte;
                start_tx      <= '1';                           -- Set to 1                       
                cmd_data_tx   <= "001";                         -- Set to data_mem
                cmd_crc       <= "01";                          -- CRC memorrization
          else 
                cmd_cptr_addr <= "11";                          -- Memorrization
                cmd_crc       <= "11";                          -- Memorrization
                cmd_data_tx   <= "001";                         -- Set to data_mem
          end if;    

        
        when crc_byte =>
          if front_ready_tx = '1' then
            next_state    <= stop_byte;
            start_tx      <= '1';           -- Set to 1
            cmd_data_tx   <= "010";         -- Set to reg_crc 
          else
            cmd_crc           <= "11";      -- Memorrization
            cmd_data_tx       <= "010";     -- Set to reg_crc
          end if;

        when stop_byte =>
          if front_ready_tx = '1' then 
            next_state    <= idle;
	          start_tx      <= '1';           -- Set to 1
	          cmd_data_tx   <= "011";         -- Set to 0x04  
	        else 
	          cmd_data_tx   <= "011";         -- Set to 0x04
          end if;

      end case;
  end process;


--------------------------------------------------------------------------

  resetn           <= not btnc;

  led(15)           <= ready;   
  led(14 downto 11) <= (others => '0');
  led(10 downto 8)  <= rts & status & ready_rx;
  led(7 downto 0)   <= data_rx when ready_rx = '1'
    else  (others => '0');
                
  -- rst = 1 : no reset
  -- cts = 0 : normal mode
  rst    <= '1'; -- reset RN-42
  cts    <= '0';
  
  -- detection de front de btnu
  process(clk, resetn) is
  begin
    if resetn = '0' then
      old_btnu  <= '1';
      start_e   <= '0';
    elsif rising_edge(clk) then
      old_btnu  <= btnu;
      start_e   <= not old_btnu and btnu ;    
    end if;
  end process;
  
  

  -- CRC : calcul pour 8 bits en une période d'horloge
  crc8 : process(clk,resetn) is
    variable tmp_crc : std_logic_vector(7 downto 0);
    variable tmp_bit : std_logic;
  begin
    if resetn ='0' then 
      reg_crc <= (others => '0') ;
    elsif rising_edge(clk) then 	
      case cmd_crc  is
       when "00" =>  -- reset
          reg_crc <= (others => '0') ;  
      
        when "01" =>  -- crc 
          tmp_crc := reg_crc;      
          for j in 7 downto 0 loop
            tmp_bit              := data_mem(j) xor tmp_crc(tmp_crc'high);
            for i in tmp_crc'high downto tmp_crc'low+1 loop
              tmp_crc(i) := tmp_crc(i-1) xor (tmp_bit and polynom(i));
            end loop;
            tmp_crc(tmp_crc'low) := tmp_bit;
          end loop;  
          reg_crc <= tmp_crc;

        when others => -- hold
          null;
      end case;
    end if;
  end process;
  
  -- message contenu dans une mémoire ROM synchrone
  mem : entity work.rom_message
    generic map ( 
      N_addr  => N_addr,
      message => message
      )
    port map  (
       clk       => clk   ,
       address   => addr ,
       data      => data_mem
       );
  
  l : entity work.uart
  generic map (
    f_clk           => f_clk,
    data_width      => 8,
    uart_rate       => uart_rate,
    parity_bit      => parity_bit,
    parity_odd      => parity_odd,
    stop_bit_1      => stop_bit_1
    )
  port map ( 
    clk          => clk,
    resetn       => resetn,
    start        => start_tx,
    rx           => rxd,
    tx           => txd,
    din          => data_tx,
    dout         => data_rx,
    ready_tx     => ready_tx,
    ready_rx     => ready_rx
    );
  
end architecture;
