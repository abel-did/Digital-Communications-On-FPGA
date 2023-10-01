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
    signal crc_Q : std_logic_vector(crc_out'high downto 0);
    constant polynome_generateur : std_logic_vector(crc_out'length downto 0) := "100000111";
begin
    -- CRC Operations
    process(clk, resetn)
    begin
      if resetn = '0' then
        crc_Q <= (others => '0');
      elsif rising_edge(clk) then
        if init = '1' then
          crc_Q <= (others => '0');
        else
          crc_Q(0) <= crc_Q(crc_out'high) xor data_in;
          for i in 1 to crc_out'high loop
          	crc_Q(i) <= crc_Q(i-1) xor ((crc_Q(crc_out'high) xor data_in) and polynome_generateur(i));   
          end loop;     
        end if;
      end if;
    end process;
	crc_out(crc_out'high downto 0) <= crc_Q(crc_out'high downto 0);
end architecture;
