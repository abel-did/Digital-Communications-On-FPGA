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
	data_miso	: 	out std_logic_vector(8*N_byte downto 0);
	error_i2c	:   out std_logic;
	update_miso :   out std_logic;
	i2c_SCL		:   out std_logic;
	
);
end entity;
--------------------------------------------------------------------------
architecture rtl of i2c_master is
	constant number_byte : natural := integer(8*(N_byte + 1));

	type state is (idle, sa0, sa1, d0, d1, ak0, ak1, so0, so1);
	signal current_state : state;
	signal next_state    : state;

	signal cmd_reg_data 		: std_logic_vector(1 downto 0);
	signal data_miso 			: std_logic_vector(number_byte downto 0);
	signal addr_wr_data_mosi 	: std_logic_vector(number_byte downto 0);

	signal reg_wr 				: std_logic;

	signal reg_ack 				: std_logic;
	signal error_i2c 			: std_logic;

	signal end_tempo 			: std_logic;

	signal end_bit 				: std_logic;

	signal end_byte 			: std_logic;
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
	-- Chargement parallele			00
	-- Decalage de 1 bit à gauche	01
	-- Memorisation					10 / 11
	process(clk, resetn)
	begin
		if resetn = '0' then
		elsif rising_edge(clk) then
			case cmd_reg_data is 
				when "00" 			=> data_miso <= addr_slave(7 downto 0) & wr & data_mosi;
				when "01" 			=> 
			end case;
		end if;
	end process;
	
	-- Registre WR 
	--------------
	-- Chargement parallele			0
	-- Memorisation 				1
	process(clk, resetn)
	begin 
		if resetn = '0' then
		elsif rising_edge(clk) then
		end if;
	end process;

	-- Registre ACK
	---------------
	-- Mise a zero					00
	-- Mise a un					01	
	-- Memorisation					10 / 11
	process(clk, resetn)
	begin
		if resetn = '0' then
		elsif rising_edge(clk) then
		end if;
	end process;

	-- CTR TEMPO
	------------
	process(clk, resetn) 
	begin
		if resetn = '0' then
		elsif rising_edge(clk) then
		end if;
	end process;

	-- CTR BIT
	----------
	-- Mise a zero 					00
	-- Incrementation				01
	-- Memorisation					10 / 11
	process(clk, resetn)
	begin
		if resetn = '0' then
		elsif rising_edge(clk) then
		end if;
	end process;

	-- CTR BYTE
	-----------
	-- Mise a zero					00
	-- Incrementation				01
	-- Memorisation					10 / 11
	process(clk, resetn)
	begin
		if resetn = '0' then
		elsif rising_edge(clk) then
		end if;
	end process;

end architecture;