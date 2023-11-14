-----------------------------------------------------
--                  uart 
-----------------------------------------------------
-- Creation : J. Cheret (ESIEE 2005), 07/2004
--            S. Piron (ESIEE 2005), 07/2004
-- Modif    : A. Exertier, 01/2005
-- Modif    : A. Exertier, 02/2017
-- Modif    : A. Exertier, 08/2019
-----------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;  
use ieee.math_real.all;

----------------------------------------------------
----             GENERIC PARAMETERS
----------------------------------------------------
-- f_clk           : FPGA main clock frequency (in Hz)
-- uart_rate       : uart rate (in bauds)
--                   (110, 300, 600, 1200, 2400, 4800, 9600, 
--                   19200, 38400, 57600 or 115200 bauds) 
-- data_width      : data width (5 to 8)
-- parity_bit      : true  => parity bit
--                   false => no parity bit
-- parity_odd      : true  => odd
--                   false => even
-- stop_bit_1      : true  => 1 stop bit only
--                   false => 2 stop bits 
-----------------------------------------------------
--                    INPUTS
-----------------------------------------------------
-- clk             : main clock
-- resetn          : asynchronous active low reset
-- start           : start a transmission
-- din             : data to transmit
-- rx              : rx (from a PC)
-----------------------------------------------------
--                  OUTPUTS
-----------------------------------------------------
-- tx              :  tx (to a PC)
-- dout            : received data
-- error_stop      : 1 => missing bit of stop 
-- error_parity    : 1 => wrong parity
-- update          : 1 => new dout 
--			            set to 1 only 1 clock cycle
-- ready_tx        : 1 => ready to transmit a new data
-- ready_rx        : 1 => not receiving data
-----------------------------------------------------
entity uart is
  generic(
    f_clk           : real     := 100_000_000.0; -- 100 MHz
    uart_rate       : real     := 9600.0;       -- 9600 bauds
    data_width      : natural := 8;          -- 8 bits
    parity_bit      : boolean := true;       -- parity bit
    parity_odd      : boolean := true;       -- odd parity bit
    stop_bit_1      : boolean := true
    );      -- 1 stop bit
  port (
    clk             : in  std_logic;
    resetn          : in  std_logic;
    -- uart
    rx              : in  std_logic;
    tx              : out std_logic;
    
    -- TX interface
    start           : in  std_logic;
    din             : in  std_logic_vector(data_width-1 downto 0);
    ready_tx        : out std_logic;
    
    -- RX interface
    dout            : out std_logic_vector(data_width-1 downto 0);
    error_stop      : out std_logic;
    error_parity    : out std_logic; 
    update_rx       : out std_logic;   
    ready_rx        : out std_logic
    );
end entity;

architecture rtl of uart is 

begin
--------------------------------
--      tx
--------------------------------
trans : entity work.uart_tx
  generic map (
    f_clk        => f_clk,
    f_baud       => uart_rate ,
    N            => data_width ,
    parity_bit   => parity_bit,
    parity_odd   => parity_odd,
    stop_bit_1   => stop_bit_1
    )
  port map ( 
    clk      => clk,
    resetn   => resetn,
    start    => start,
    data     => din,
    ready    => ready_tx,
    tx       => tx
    );
---------------------------------------
--              rx
---------------------------------------
recept :  entity work.uart_rx
  generic map (
    f_clk        => f_clk,
    f_baud       => uart_rate ,
    N            => data_width ,
    parity_bit   => parity_bit,
    parity_odd   => parity_odd,
    stop_bit_1   => stop_bit_1
    )
  port map ( 
    clk            => clk,
    resetn         => resetn,
    rx             => rx,
    data           => dout,
    error_stop     => error_stop,
    error_parity   => error_parity,
    update_rx      => update_rx,
    ready          => ready_rx
    );
     
end architecture ;
