---------------------------------------
--  reception message via pmod_bt2
---------------------------------------
-- affichage sur PC (putty)
-- ack/nak à l'émetteur après verif CRC
---------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee. math_real.all;

entity reception is
  generic  (
    f_clk      : real     := 100_000_000.0;
    uart_rate  : real     := 115_200.0;
    parity_bit : boolean  := false ;    
    parity_odd : boolean  := true  ;     
    stop_bit_1 : boolean  := true  
  );
  port (
    clk         : in  std_logic;  
    btnc        : in  std_logic;  -- btnc
    led         : out std_logic_vector(15 downto 0);
    -- uart / usb :
    --rx          : in  std_logic;
    tx          : out std_logic;
    -- BT2  
    rxd         : in  std_logic;
    txd         : out std_logic;
    rts         : in  std_logic;
    cts         : out std_logic;
    status      : in  std_logic;
    rst         : out std_logic    
    ); 
end entity;

architecture rtl of reception is
  signal resetn        : std_logic;
  
  -- uart
  signal start_tx      : std_logic;
  signal ready_tx      : std_logic;
  signal ready_rx      : std_logic;
  signal data_tx       : std_logic_vector(7 downto 0);
  signal data_rx       : std_logic_vector(7 downto 0);
  signal update_rx     : std_logic;

  -- crc
  constant polynom     : std_logic_vector(7 downto 0) := X"07";
  signal reg_crc       : std_logic_vector(7 downto 0);
  signal cmd_crc       : std_logic_vector(1 downto 0);  

begin

  resetn           <= not btnc;
  tx               <= rxd;  -- connexion directe au PC 
  
  led(15 downto 11) <= (others => '0');
  led(10 downto 8)  <= rts & status & ready_rx;
  led(7 downto 0)   <= reg_crc;
                
  -- rst = 1 : no reset
  -- cts = 0 : normal mode
  rst    <= '1'; -- reset RN-42
  cts    <= '0';
  
         
  data_tx  <= X"06" when reg_crc = X"00"  -- ACK
         else X"15";                      -- NAK
  start_tx <= '1' when update_rx = '1' and data_rx = X"04"
         else '0';
         
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
    update_rx    => update_rx,
    ready_tx     => ready_tx,
    ready_rx     => ready_rx
    );
  
   -- synthesis translate_off
  process is
  begin
    wait until rising_edge(ready_rx);
    report "data_rx : Ox"& to_hstring(data_rx)&" soit en ASCII "&character'val(to_integer(unsigned(data_rx)));
  end process;
   -- synthesis translate_on
    
  cmd_crc <= "00" when update_rx = '1' and data_rx = X"02"
        else "01" when update_rx = '1' and data_rx /= X"04"
        else "10";
        
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
            tmp_bit              := data_rx(j) xor tmp_crc(tmp_crc'high);
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
  
end architecture;
