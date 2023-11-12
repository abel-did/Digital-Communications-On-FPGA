------------------------------------------------------
--      demo PmodAD1 => Nexys 4 DRR, Basys3
------------------------------------------------------
-- Creation     : A. Exertier, 09/2019
-- Modification : A. Exertier, 08/2022
------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
------------------------------------------------------
--                GENERIC PARAMETERS
------------------------------------------------------
-- f_clk    : main clock frequency
-- f_spi    : spi frequency
------------------------------------------------------
--                   INPUTS
------------------------------------------------------
-- clk      : main clock
-- btnc     : asynchronous active low high
-- btnu     : start conversion
-- sdata1   : spi data (PMOD AD1)
-- sdata2   : spi data (PMOD AD1)
-- sw(0)    : select displayed data (0 =>data1, 1 => data2)
-- sw(1)    : mode selection
--            0 => continuous data acquisition
--            1 => data acquisition at pression of btnu
------------------------------------------------------
--                   OUTPUTS
------------------------------------------------------
-- sclk     : spi clock  (PMOD AD1)
-- cs       : spi chip select (PMOD AD1)
-- led      : 16 leds => ready reg_update 00 data(12 bits)
--            reg_update inverted when new_data received
------------------------------------------------------

entity demo_pmod_ad1 is  
  generic(
    f_clk   : real := 100_000_000.0; -- 100 MHz (nexys 4 ddr)
    f_spi   : real := 10_000_000.0      -- <= 20 MHz     
    );           
  port (
    clk     : in  std_logic;  
    btnc    : in  std_logic;  -- reset 
    btnu    : in  std_logic;  -- start
    sdata1  : in  std_logic;
    sdata2  : in  std_logic;
    sw      : in  std_logic_vector(1 downto 0);
    sclk    : out std_logic;
    cs      : out std_logic;
    led     : out std_logic_vector(15 downto 0)
    );
end entity;

architecture rtl of demo_pmod_ad1 is
  constant N         : positive := 12;  
  signal resetn      : std_logic;
  signal data1       : std_logic_vector(N-1 downto 0);
  signal data2       : std_logic_vector(N-1 downto 0);
  signal reg1        : std_logic_vector(N-1 downto 0);
  signal reg2        : std_logic_vector(N-1 downto 0);
  signal ready       : std_logic;
  signal reg_start   : std_logic_vector(1 downto 0);
  signal spi_start   : std_logic;  
  signal reg_update  : std_logic;
  signal old_ready   : std_logic;
begin

  resetn <= not btnc;

  led(15 downto 12) <= ready & reg_update & "00";
  led(11 downto 0)  <= reg1 when sw(0) = '0' else 
                       reg2;  
                       
  spi_start  <= '1' when sw(1) = '0'   -- continuous data acquistion
    else reg_start(1) and not reg_start(0);      
         
  process(clk,resetn) is
  begin
    if resetn = '0' then 
      reg_start  <= "11";
      reg_update <= '1';
      old_ready  <= '0';
      reg1       <= (others => '0');
      reg2       <= (others => '0');
    elsif rising_edge(clk) then
      reg_start <= btnu & reg_start(1);
      old_ready <= ready;
      if (ready= '1' and old_ready ='0') then 
        reg_update <= not reg_update;
        reg1       <= data1;
        reg2       <= data2;
      end if;
    end if;
  end process;   
           
  dut : entity work.spi_pmod_ad1   
    generic map(
      f_clk   => f_clk, 
      f_spi   => f_spi
      )     
    port map (
      clk           => clk         ,
      resetn        => resetn      ,
      start         => spi_start   ,
      sdata1        => sdata1      ,
      sdata2        => sdata2      ,
      sclk          => sclk        ,
      cs            => cs          ,
      ready         => ready       ,
      data1         => data1       , 
      data2         => data2 
      ); 
   


 end architecture; 
  