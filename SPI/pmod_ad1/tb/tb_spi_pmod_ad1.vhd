
library ieee;
use ieee.std_logic_1164.ALL;
 

 
entity tb_spi_pmod_ad1 is
end entity;
 
architecture testbench of tb_spi_pmod_ad1 is 
   constant N        : positive := 12;
   signal clk        : std_logic := '0';
   signal resetn     : std_logic := '0';
   signal start      : std_logic := '0';
   

   signal cs         : std_logic;
   signal sclk       : std_logic;
   signal ready      : std_logic;
   signal sdata1     : std_logic ;
   signal data1      : std_logic_vector(N-1 downto 0);
   signal sdata2     : std_logic ;
   signal data2      : std_logic_vector(N-1 downto 0);   
  
   constant hp       : time := 5 ns;
   constant per      : time := 2*hp;
 
   -- test
   constant Nt            : positive := 4;   -- nombre de tests
   constant Nm            : positive := 16;  -- nombre de bits du message
   type t_message is array (natural range 1 to Nt) of std_logic_vector(Nm-1 downto 0);
   constant message : t_message := (
   	"0000100000000000" ,  -- 1er vecteur : Test DB11
    	"0000000000000001" ,  -- 2e  vecteur : Test DB00
	"0000100100000001" ,  -- 3e  vecteur : Test all data
	"0000100000111000"    -- 4e  vecteur : Test all data
    );

begin 
  clk    <= not clk after hp;


  dut : entity work.spi_pmod_ad1
    generic map(
      f_clk => 100_000_000.0, 
      f_spi => 10_000_000.0
    )     
    port map (
      clk     => clk     ,
      resetn  => resetn  ,
      start   => start   ,
      data1   => data1,
      data2   => data2,
      sclk    => sclk    ,
      cs      => cs      ,
      ready   => ready   ,
      sdata1  => sdata1   , 
      sdata2  => sdata2 
      );  
    

  stimuli: process is
  begin    
	sdata1  <= '0';
	sdata2  <= '0';
	resetn  <= '0';    -- activation du reset
    	wait for per;
    	resetn  <= '1';    -- desactivation du reset   
	

	-- Test Stimulus Vector 1 - 4
    	for i in 1 to Nt loop
      	report "Test "&integer'image(i);
      	
	start   <= '1';	   -- Start
	wait until falling_edge(cs);
        start   <= '0';

      	--envoi des bits
      		for j in Nm-1 downto 0 loop
        		sdata1 <= message(i)(j) ; 	-- MSB du bit j vecteur i
			sdata2 <= message(Nt-i+1)(j); 	-- MSB du bit j vecteur Nt-i
        		wait until falling_edge(sclk);
      		end loop;
		wait until rising_edge(ready);
		if data1 /= message(i)(11 downto 0) then 
       			report "Canal 1 SPI not OK" severity warning;
       			report "Canal 1 resultat attendu : 0x"& to_hstring(message(i)(11 downto 0));
       			report "Canal 1 resultat obtenu : 0x"& to_hstring(data1);
      		else
      			report "Canal 1 SPI OK" severity warning;
       			report "Canal 1 resultat obtenu : 0x"& to_hstring(data1);
      		end if;
		
		if data2 /= message(Nt-i+1)(11 downto 0) then 
       			report "Canal 2 SPI not OK" severity warning;
       			report "Canal 2 resultat attendu : 0x"& to_hstring(message(Nt-i+1)(11 downto 0));
       			report "Canal 2 resultat obtenu : 0x"& to_hstring(data2);
      		else
      			report "Canal 2 SPI OK" severity warning;
       			report "Canal 2 resultat obtenu : 0x"& to_hstring(data2);
      		end if;
		
	end loop;

	-- Test Stimulus Start = '1' 
	for i in 1 to Nt loop
      	report "Test "&integer'image(i+Nt);
      	
	start <= '1';

      	--envoi des bits
      		for j in Nm-1 downto 0 loop
        		sdata1 <= message(i)(j) ; 	-- MSB du bit j vecteur i
			sdata2 <= message(Nt-i+1)(j); 	-- MSB du bit j vecteur Nt-i
        		wait until falling_edge(sclk);
      		end loop;
		wait until rising_edge(ready);
		if data1 /= message(i)(11 downto 0) then 
       			report "Canal 1 SPI not OK" severity warning;
       			report "Canal 1 resultat attendu : 0x"& to_hstring(message(i)(11 downto 0));
       			report "Canal 1 resultat obtenu : 0x"& to_hstring(data1);
      		else
      			report "Canal 1 SPI OK" severity warning;
       			report "Canal 1 resultat obtenu : 0x"& to_hstring(data1);
      		end if;
		
		if data2 /= message(Nt-i+1)(11 downto 0) then 
       			report "Canal 2 SPI not OK" severity warning;
       			report "Canal 2 resultat attendu : 0x"& to_hstring(message(Nt-i+1)(11 downto 0));
       			report "Canal 2 resultat obtenu : 0x"& to_hstring(data2);
      		else
      			report "Canal 2 SPI OK" severity warning;
       			report "Canal 2 resultat obtenu : 0x"& to_hstring(data2);
      		end if;
		
	end loop;



    wait;
  end process;
    
end architecture;
