library ieee;
use ieee.std_logic_1164.all;

entity tb_crc_8 is
end entity tb_crc_8;

architecture tesbench of tb_crc_8 is
  constant half_period   : time := 10 ns;
  constant period        : time := 2*half_period;  
  signal clk             : std_logic := '0';
  signal resetn          : std_logic;
  signal data_in         : std_logic;
  signal init            : std_logic;
  signal crc_out         : std_logic_vector(7 downto 0);
  
  -- test
  constant Nt            : positive := 5;   -- nombre de tests
  constant Nm            : positive := 40;  -- nombre de bits du message
  
  constant Nb		 : positive := 8; 	-- nombre de bit du crc
   
  type t_message is array (natural range 1 to Nt) of std_logic_vector(Nm-1 downto 0);
  type t_crc     is array (natural range 1 to Nt) of std_logic_vector(crc_out'range);
  
  type t_crc_correct is array (natural range 1 to Nt) of std_logic_vector(Nb-1 downto 0);
  
  constant message : t_message := (
    X"0000000001" ,  -- 1er vecteur : 1 => CRC = 0x07
    X"0000000002" ,  -- 2e  vecteur : 2 => CRC = 0x0E 
    X"0041C0041F" ,  -- 3e vecteur     => CRC = x^3 + 1 = 0x09
    X"02CC408592" ,  -- 4e vecteur     => CRC = 0 
    X"53696D7520"    -- 5e vecteur     => CRC = F8
    );
    
  constant correct_result : t_crc_correct := (
  	X"07",
  	X"0E",
  	X"09",
  	X"00",
  	X"F8"
  ); 
  

begin

  clk  <= not clk  after half_period;
  
	-- stimuli 	
  stimuli : process is
  variable crc_ok : boolean := true;
  begin
    resetn  <= '0';    -- activation du reset
    init    <= '0';
    data_in <= '0';
    wait for 2*period;
    resetn  <= '1';    -- desactivation du reset  
    wait for 3*period;
    
    -- tests
    -- pour chaque vecteur de test :
    for i in 1 to Nt loop
      report "Test "&integer'image(i);  
      -- Affichage dans le fenetre de transcript du numero du vecteur de test
      -- interger'image(j) traduit l'entier j en chaine de carateres (string)
      wait until rising_edge(clk);
      init    <= '1';               -- reset du CRC
      
      wait until rising_edge(clk);
      init <= '0';   -- CRC : mode normal
      --envoi des bits
      for j in Nm-1 downto 0 loop
        data_in <= message(i)(j) ; -- MSB du bit j vecteur i
        wait until rising_edge(clk);	
      end loop;
      
      data_in <= '0';
      
      wait until rising_edge(clk);
      
      if crc_out /= correct_result(i) then 
       		report "CRC not OK" severity warning;
       		report "resultat attendu : 0x"& to_hstring(correct_result(i));
       		report "resultat obtenu : 0x"& to_hstring(crc_out);
      else
      		report "CRC OK" severity warning;
       		report "resultat obtenu : 0x"& to_hstring(crc_out);
      end if;
      
    
      data_in <= '0';
      -- attente entre 2 tests
      wait for 20*period;  
    end loop; 
    -- fin des tests    
    wait;     
  end process;  


 	


  -- device under test : CRC
  dut : entity work.crc_8
  port map(
    clk      => clk,
    resetn   => resetn,
    data_in  => data_in,
    init     => init,
    crc_out  => crc_out
    );
  
end architecture;
