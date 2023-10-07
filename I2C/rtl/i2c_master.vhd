library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
--------------------------------------------------------------------------
entity i2c_master is
	generic (
		N_byte : positive := 8
);
port (
	clk			:	in std_logic;
	resetn		:	in std_logic;
	start		:   in std_logic;
	ready		:   out std_logic;
	wr			:   in std_logic;
	addr_slave  :   in std_logic_vector(7 downto 0);
	data_mosi	:   in std_logic_vector(8*N_byte downto 0);
	data_miso	: 	out std_logic_vector(8*N_byte downto 0)
);
end entity;
--------------------------------------------------------------------------
architecture rtl of i2c_master is
	type state is (idle, sa0, sa1, d0, d1, ak0, ak1, so0, so1);
	signal current_state : state;
	signal next_state    : state;
begin
--------------------------------------------------------------------------
--	Control Part														--
--------------------------------------------------------------------------
	process(resetn, clk) is
	begin
		if resetn = '0' then
			current_state <= idle;
		elsif rising_edge(clk) then
			current_state <= next_state;
		end if;
	end process;
	
	process(current_state, start, end_tempo, end_bit, end_byte) is
	begin
		case current_state is 
			when idle =>
			when sa0  =>
			when sa1  =>
			when d0   =>
			when d1   =>
			when ak0  =>
			when ak1  =>
			when so0  =>
			when so1  =>
		end case;
	end process;
--------------------------------------------------------------------------
--	Operative Part														--
--------------------------------------------------------------------------
	-- Registre Data
	----------------
	-- Chargement parallele
	-- Decalage de 1 bit à gauche
	-- Memorisation
	process(clk, resetn)
	begin
		if resetn = '0' then
		elsif rising_edge(clk) then
		end if;
	end process;
	
	-- Registre WR 
	--------------
	-- Chargement parallele
	-- Memorisation 
	process(clk, resetn)
	begin 
		if

end architecture;
