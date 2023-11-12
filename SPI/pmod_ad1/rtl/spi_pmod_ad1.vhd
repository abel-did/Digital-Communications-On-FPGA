------------------------------------------------------
--   SPI 
--   data transferred on falling edge of sclk
--   Authors : Elio KHAZAAL Abel DIDOUH
------------------------------------------------------
-- Creation : 09/2019, A. Exertier
------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

------------------------------------------------------
--                GENERIC PARAMETERS
------------------------------------------------------
-- f_clk     : main clock frequency
-- f_spi     : spi frequency
------------------------------------------------------
--                   INPUTS
------------------------------------------------------
-- clk      : main clock
-- resetn   : asynchronous active low reset
-- start    : start conversion
-- sdata1   : spi serial data from slave (channel 1)
-- sdata2   : spi serial data from slave (channel 2)
------------------------------------------------------
--                   OUTPUTS
------------------------------------------------------
-- data1    : parallel data (channel 1)
-- data1    : parallel data (channel 2)
-- sclk     : spi clock
-- cs       : spi chip select
-- ready    : interface is ready
------------------------------------------------------


entity spi_pmod_ad1 is  
  generic(
    f_clk   : real := 100_000_000.0; -- 100 MHz
    f_spi   : real := 10_000_000.0
  );      
  port (
    clk           : in  std_logic;  
    resetn        : in  std_logic;
    start         : in  std_logic;
    data1         : out std_logic_vector(11 downto 0);
    data2         : out std_logic_vector(11 downto 0);
    ready         : out std_logic;
    
    -- spi
    sdata1        : in std_logic;
    sdata2        : in std_logic;
    sclk          : out std_logic;
    cs            : out std_logic 
    );
end entity;

architecture rtl of spi_pmod_ad1 is
	constant x : natural := integer(ceil(f_clk/f_spi/2.0)); 
	-- Operative part
	signal data_1_srt : std_logic_vector(11 downto 0) := (others => '0');
	signal data_2_srt : std_logic_vector(11 downto 0) := (others => '0');

	signal sclk_wire : std_logic;
	signal cmd_SCLK : std_logic_vector(1 downto 0);
	
	signal end_data : std_logic;
	signal cmd_cptr : std_logic_vector(1 downto 0);
	signal ctr_data : natural range 0 to 16;
	
	signal data_out : std_logic_vector(11 downto 0); --MISO1
	signal data_out_2 : std_logic_vector(11 downto 0); --MISO2
	signal cmd_MISO : std_logic;
	
	signal end_tempo : std_logic;
	signal cmd_tempo : std_logic; 
	signal ctr_tempo : natural range 0 to x-1;
	
	-- Control part
	type state is (idle, init_sclk, data, end_sclk, end_transmission, cs_delay);
	signal current_state	: state;
	signal next_state 	: state;
	
begin
 
--------------------------------------------------------------------------
-- Operative Part							                            --
--------------------------------------------------------------------------
	
	data1 <= data_1_srt;
	
    data2 <= data_2_srt;
	-- Continuous Data
	------------------
	-- Memorization
	-- Changement de donnee
	process(clk, resetn) 
	begin
	   if resetn = '0' then
	       data_1_srt <= (others => '0');
	       data_2_srt <= (others => '0');
	   elsif rising_edge(clk) then
	       case end_data is
	           when '1' => 
	               data_1_srt <= data_out;
	               data_2_srt <= data_out_2;
	           when others => 
	               data_1_srt <= data_1_srt;
	               data_2_srt <= data_2_srt;
	       end case;
	   end if;
	end process;
	

	
	-- Clock Divider
	-------------------
	-- Incrementation : 1
	-- Set to 0       : 0
	end_tempo <= '1' when ctr_tempo >= (x-1) else
		     '0';
	process(clk, resetn)
	begin 
		if resetn = '0' then
			ctr_tempo <= 0;
		elsif rising_edge(clk) then
			case cmd_tempo is 
				when '0' 	=> ctr_tempo <= 0;
				when others 	=> ctr_tempo <= ctr_tempo + 1;
			end case;
		end if;
	end process;
	
	-- Serial In Parallel Out
	-------------------------
	-- Shift Left
	-- Memorization
	process(clk, resetn)
	begin
		if resetn = '0' then 
			data_out <= (others => '0');
			data_out_2 <= (others => '0');
		elsif rising_edge(clk) then
			case cmd_MISO is
				when '0' 	=>
                                   data_out <= data_out;
				   data_out_2 <= data_out_2; 
				when others 	=> 
                                   data_out <= data_out(10 downto 0) & sdata1;
				   data_out_2 <= data_out_2(10 downto 0) & sdata2;
			end case;
		end if;
	end process;
	
	-- Bit counter Data
	-------------------
	-- Incrementation
	-- Memorization
	-- Set to 0
	end_data <= '1' when ctr_data = 16 else
		    '0';
	process(clk, resetn)
	begin
		if resetn = '0' then
			ctr_data <= 0;
		elsif rising_edge(clk) then
			case  cmd_cptr is
				when "00" 		=> ctr_data <= 0;
				when "01" 		=> ctr_data <= ctr_data +1;
				when others 	        => ctr_data <= ctr_data;
			end case;
		end if;
	end process;
	
	-- Frequency Divider SCLK
	-------------------------
	-- Memorization 
	-- Toggle
	-- Set to 1
	process(clk, resetn)
	begin
		if resetn = '0' then
			sclk_wire <= '1';
		elsif rising_edge(clk) then 
			case cmd_sclk is 
				when "00" 		=> sclk_wire <= sclk_wire;
				when "01" 		=> sclk_wire <= not sclk_wire;
				when others 	        => sclk_wire <= '1';	
			end case;	
		end if;		
	end process;
	sclk <= sclk_wire;
	
--------------------------------------------------------------------------
-- Control Part								--
--------------------------------------------------------------------------
	process(resetn, clk) is 
	begin
		if resetn = '0' then
			current_state <= idle;
		elsif rising_edge(clk) then
			current_state <= next_state;
		end if;
	end process;
	
	process(current_state, start, end_tempo, end_data, sclk_wire, ctr_data) is
	begin
		next_state <= current_state;
		
		cs 		<= '1';		-- Set to 1
		cmd_tempo 	<= '0'; 	-- Set to 0
		cmd_MISO 	<= '0'; 	-- M
		cmd_sclk	<= "11"; 	-- Set to 1
		cmd_cptr 	<= "00"; 	-- Set to 0
		ready		<= '1';          -- Set to 1
		
		case current_state is
			
		when idle => 
			if start = '1' then
				next_state <= init_sclk;
				--cmd_tempo 	<= '1'; 	-- Incrementation
			end if;
			
			cs 		<= '1';		-- Set to 1
			cmd_tempo 	<= '0'; 	-- Set to 0
			cmd_MISO 	<= '0'; 	-- M
			cmd_sclk	<= "11"; 	-- Set to 1
			cmd_cptr 	<= "00"; 	-- Set to 0
			ready		<= '1';         -- Set to 1
		
		when init_sclk =>
			cs 		<= '0';		-- Set to 0
			cmd_tempo 	<= '1'; 	-- Incrementation
			cmd_MISO 	<= '0'; 	-- Memorization
			cmd_sclk	<= "00"; 	-- Memorization
			cmd_cptr 	<= "00"; 	-- Set to 0
			ready		<= '0';          -- Set to 0
			if end_tempo = '1' then
				cmd_tempo <= '0'; 	-- Set to 0
				cmd_sclk	<= "01"; -- Toggle
				next_state <= data;
				
			end if;
			
			
			
		when data => 
			if end_data = '1' and end_tempo = '1' then 
				cmd_tempo  <= '0'; 	-- Set to 0
				cmd_cptr   <= "00"; 	-- Set to 0
				next_state <= end_sclk;
				
			else
				next_state <= data;
			end if;
			
			cs 			<= '0';	-- Set to 0
			
			if end_tempo = '1' and sclk_wire = '1' and ctr_data = 16 then		-- End 
				cmd_sclk	<= "11"; -- Set to 1
				cmd_tempo 	<= '0';  -- Set to 0
				cmd_cptr 	<= "11"; -- Memorization
				cmd_MISO 	<= '0';  -- Memorization

			elsif end_tempo = '1' and sclk_wire = '0' and ctr_data = 15 then		-- End 
				cmd_sclk	<= "11"; -- Set to 1
				cmd_tempo 	<= '0';  -- Set to 0
				cmd_cptr 	<= "01"; -- Incrementation
				cmd_MISO 	<= '0';  -- Memorization

			elsif end_tempo = '1' and sclk_wire = '1' then		-- Front descendant
				cmd_sclk	<= "01"; -- Toggle
				cmd_tempo 	<= '0';  -- Set to 0
				cmd_cptr 	<= "11"; -- Memorization
				cmd_MISO 	<= '0';  -- Memorization
			elsif end_tempo = '1' and sclk_wire = '0' then 	-- Front montant
				cmd_sclk	<= "01"; -- Toggle
				cmd_tempo 	<= '0';  -- Set to 0
				cmd_cptr 	<= "01"; -- Incrementation
				cmd_MISO 	<= '1';  -- Shift left
			else 
				cmd_sclk	<= "00"; -- Memorization
				cmd_tempo 	<= '1';  -- Incrementation
				cmd_cptr 	<= "11"; -- Memorization
				cmd_MISO 	<= '0';  -- Memorization
			end if;
			ready			<= '0';          -- Set to 0
			
			
		when end_sclk =>
			
			cs 		<= '0';		-- Set to 0
			cmd_sclk	<= "11"; 	-- Set to 1
			cmd_tempo 	<= '1';		-- Incrementation				
			cmd_cptr	<= "00";	-- Set to 0
			cmd_MISO	<= '0';		-- Memorization
			ready		<= '0';          -- Set to 0

			if end_tempo = '1' then
				cmd_tempo 	<= '0';		-- Set to 0
				next_state	<= end_transmission;
			end if;
			
			
			
			
		when end_transmission =>
			cs 		<= '1';		-- Set to 1
			cmd_sclk	<= "11"; 	-- Set to 1
			cmd_tempo 	<= '1';		-- Incrementation				
			cmd_cptr	<= "00";	-- Set to 0
			cmd_MISO	<= '0';		-- Memorization
			ready		<= '0';          -- Set to 0

			if end_tempo = '1' then
				next_state	<= cs_delay;
				cmd_tempo 	<= '0';		-- Set to 0
				
			end if;
			
			

			

		when cs_delay =>
			cs 		<= '1';		-- Set to 1
			cmd_sclk	<= "11"; 	-- Set to 1
			cmd_tempo 	<= '1';		-- Incrementation				
			cmd_cptr	<= "00";	-- Set to 0
			cmd_MISO	<= '0';		-- Memorization
			ready		<= '0';          -- Set to 0

			if end_tempo = '1' then
				next_state	<= idle;
				cmd_tempo 	<= '0';		-- Set to 0
				
			end if;
			
			
			
		end case;
	end process;
end architecture;
