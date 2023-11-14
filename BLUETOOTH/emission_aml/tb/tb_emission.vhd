
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee. math_real.all;


entity tb_emission is
end entity;

architecture rtl of tb_emission is
  constant  N_addr     : positive := 7;  
  constant  f_clk      : real     := 100_000_000.0;
  constant  uart_rate  : real     := 115_200.0;
  constant parity_bit  : boolean  := false; 
  constant parity_odd  : boolean  := true;
  constant stop_bit_1  : boolean  := true;
  constant hp          : time     := 5 ns;
  constant per         : time     := 2*hp;

  signal  clk          : std_logic := '0';  
  signal  btnc         : std_logic;  -- btnc
  signal  btnu         : std_logic;  -- start transfer
  signal  led          : std_logic_vector(15 downto 0);
  -- BT2   : emission
  signal  rxd          : std_logic;
  signal  txd          : std_logic;
  signal  rts          : std_logic;
  signal  cts          : std_logic;
  signal  rst          : std_logic;
  signal  status       : std_logic;
  
  -- BT2 : reception
  signal  rxd_r        : std_logic;
  signal  txd_r        : std_logic;
  signal  rts_r        : std_logic;
  signal  cts_r        : std_logic;
  signal  rst_r        : std_logic;
  signal  status_r     : std_logic; 	
  signal  led_r        : std_logic_vector(15 downto 0);    
begin
  
  clk <= not clk after hp;
  
  process is
  begin
    btnc     <= '1';
    btnu     <= '0';
    --rxd      <= '1';
    rts      <= '1';
    status   <= '1';
    --rxd_r    <= '1';
    rts_r    <= '1';
    status_r <= '1';
    wait for per;
    btnc   <= '0'; -- disable reset
    
    wait for per;
    btnu <= '1';
    wait for per;
    btnu <= '0';
    
    wait until rising_edge(led(15));
    wait for 100*per;
    
    wait for per;
    btnu <= '1';
    wait for per;
    btnu <= '0';    
    
    wait until rising_edge(led(15));
    wait for 100*per;
    
    wait for per;
    btnu <= '1';
    wait for per;
    btnu <= '0';    
    
    wait until rising_edge(led(15));
    wait for 100*per;
    
    wait for per;
    btnu <= '1';
    wait for per;
    btnu <= '0';    
    
    wait until rising_edge(led(15));
    wait for 100*per;
    
    wait for per;
    btnu <= '1';
    wait for per;
    btnu <= '0';    
    
    wait;
  end process;
  
  check : process(led(7 downto 0)) is
  begin
    if    led(7 downto 0) = X"06" then
      report "ACK";
    elsif led(7 downto 0) = X"15" then
     report "NOAK";
    end if;
  end process;
  
  
  -- fpga : emetteur
  dut : entity work.emission
    generic  map (
      N_addr     => N_addr     ,
      f_clk      => f_clk      ,
      uart_rate  => uart_rate  ,
      parity_bit => parity_bit ,    
      parity_odd => parity_odd ,     
      stop_bit_1 => stop_bit_1 ,
      message    => "Bravo! La transmission est operationnelle. Verifiez CRC OK : 0x06 sur led, si 0x15, erreur de CRC.    "
    )
    port map (
      clk         => clk    ,
      btnc        => btnc   ,
      btnu        => btnu   ,
      led         => led    ,
      -- BT2  
      rxd         => rxd    ,
      txd         => txd    ,
      rts         => rts    ,
      cts         => cts    ,
      status      => status ,
      rst         => rst    
      ); 
  
  -- fpga : recepteur 
  rxd_r <= txd;
  rxd   <= txd_r;    
  retour : entity work.reception
    generic  map (
      f_clk      => f_clk       ,
      uart_rate  => uart_rate   ,
      parity_bit =>  parity_bit ,    
      parity_odd =>  parity_odd ,     
      stop_bit_1 =>  stop_bit_1
    )
    port map (
      clk         => clk        ,
      btnc        => btnc       ,
      led         => led_r      ,
      -- BT2  
      rxd         => rxd_r      ,
      txd         => txd_r      ,
      rts         => rts_r      ,
      cts         => cts_r      ,
      status      => status_r   ,
      rst         => rst_r    
      ); 
    
    
end architecture;
