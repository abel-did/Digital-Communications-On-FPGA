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
   
  type t_message is array (natural range 1 to Nt) of std_logic_vector(Nm-1 downto 0);
  type t_crc     is array (natural range 1 to Nt) of std_logic_vector(crc_out'range);
  
  constant message : t_message := (
    X"0000000001" ,  -- 1er vecteur : 1 => CRC = ??
                     -- a vous de calculer a la main par division le CRC 
    X"0000000002" ,  -- 2e  vecteur : 2 => CRC = ??
                     -- a vous de calculer a la main par division le CRC                 
    X"0041C0041F" ,  -- 3e vecteur     => CRC = x^3 + 1
    X"02CC408592" ,  -- 4e vecteur     => CRC = 0 
    X"53696D7520"    -- 5e vecteur     => CRC = ??
                     -- code ASCII de "Simu " (utile pour tp Bluetooth)
                     -- a vous de determiner sa valeur par lecture sur le chronogramme
    );
  

begin

  clk  <= not clk  after half_period;
  
	-- stimuli 	
  stimuli : process is
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