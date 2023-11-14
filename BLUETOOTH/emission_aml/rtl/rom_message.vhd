------------------------------------------
-- Rom contenant un texte ASCII (un caractere = 8 bits)
-------------------------------------------
-- Creation      : 05/2020, Y. Blanchard
-- Modification  : 08/2020, A. Exertier


library ieee;
use ieee.math_real.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------
--        GENERIC PARAMETERS
-------------------------------------------
-- N_addr  : nombre de bits de l'adresse
-- message : contenu de la mémoire spécifié en texte (chaîne de caractères)
-------------------------------------------
--           INPUTS
-------------------------------------------
-- clk      : clock
-- address  : address
-------------------------------------------
--           OUTPUTS
-------------------------------------------
-- data      : donnée de 8 bits (ASCII code)
-------------------------------------------


entity rom_message is 
  generic ( 
    N_addr  : positive := 4;
    message : string   := "Message contenu par la ROM"
    );
  port (
    clk     : in  std_logic;
    address : in  std_logic_vector(N_addr-1 downto 0);
    data    : out std_logic_vector(7 downto 0)
  );
begin
end entity;

architecture rtl of rom_message is
  -- déclaration d'un type tableau d'octets pour la mémoire
  type t_rom is array(natural range 0 to 2**N_Addr-1) of std_logic_vector(data'range);
  
  -- déclaration d'une fonction qui permet d'initialiser la mémoire
  -- la fonction convertit la chaine de caracteres en binaire
  -- si le message est plus court que ce que peut contenir la mémoire
  -- on remplit avec 0x00 
  function init_rom(mes : string) return t_rom is
    variable tmp_rom: t_rom := (others => X"00");
  begin
   for i in 0 to mes'high-1 loop
      exit when i > 2**N_addr-1;
      tmp_rom(i) := std_logic_vector(to_unsigned(character'pos(message(i+1)), data'length));
   end loop;
   
   return tmp_rom; 
  end function;  
  
 signal my_memory : t_rom := init_rom(message); 
 
begin  
  process(clk)
  begin
    if rising_edge(clk) then
      data <= my_memory(to_integer(unsigned(address)));
    end if;
  end process;    
end architecture;