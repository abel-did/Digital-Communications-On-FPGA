library ieee;
use ieee.std_logic_1164.all;

--------------------------------------------
--           CRC 8 bits 
-- g(x) = 1 + x + x^2 + x^8
--------------------------------------------
-- Authors : Elio KHAZAAL & Abel DIDOUH
-- Date    : 18 / 09 / 2023
--------------------------------------------
--        INPUTS
--------------------------------------------
-- clk     : main clock
-- resetn  : asynchronous active low reset
-- data_in : data input
-- init    : synchronous initialisation
--            init = 1 => initialisation
--            init = 0 => CRC
--------------------------------------------
--        OUTPUT
--------------------------------------------
-- crc_out : CRC (8 bits)
-- MSB => x^7
-- LSB => x^0
--------------------------------------------

entity crc_8 is
  port (
    clk      : in  std_logic;
    resetn   : in  std_logic;
    data_in  : in  std_logic;
    init     : in  std_logic;
    crc_out  : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of crc_8 is
    signal crc_dff : std_logic_vector(7 downto 0);
begin
    process(clk, resetn, init)
    begin
      if resetn = '0' then
        crc_out <= (others => '0');
        crc_dff <= (others => '0');
      elsif rising_edge(clk) then
        if init = '1' then
          crc_dff <= (others => '0');
          crc_out <= (others => '0');
        else 
          crc_dff(0) <= crc_dff(7) xor data_in;
          crc_dff(1) <= crc_dff(0) xor crc_dff(7) xor data_in;
          crc_dff(2) <= crc_dff(1) xor crc_dff(7) xor data_in;
          crc_dff(7 downto 3) <= crc_dff(6 downto 2);
        end if; 
      end if;
      crc_out(7 downto 0) <= crc_dff(7 downto 0);
    end process;
end architecture;
