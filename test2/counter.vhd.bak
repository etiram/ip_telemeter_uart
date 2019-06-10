library ieee;
USE ieee.std_logic_1164.all;

entity Counter is 
	generic (n : POSTIVE := 10);
	port (clk : in STD_LOGIC,
			enable : in STD_LOGIC,
			reset : in STD_LOGIC,
			output : out STD_LOGIC_VECTOR (n-1 downto 0));
end Counter;

architecture Behavioral of Counter is
signal count : STD_LOGIC_VECTOR (n-1 downto 0);
begin
process (clk, reset)

	begin
	if (reset = '0') then 
		count <= (others => '0');
	elsif(clk'event and clk='1') then
		if (enable = '1') then
			count <= count + 1;
		end if;
	end if;
end process;
output <= count;
end  Behavioral;