LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.NUMERIC_STD.ALL;

ENTITY telemeter IS
	PORT(
		start 	: 	IN		STD_LOGIC;
		echo		: 	IN		STD_LOGIC;
		clk		: 	IN		STD_LOGIC;
		data		:	OUT	STD_LOGIC_VECTOR(7 downto 0);
		busy		:	OUT	STD_LOGIC;
		trigger	:	OUT	STD_LOGIC);
END telemeter;

architecture main of telemeter IS
	signal is_busy : STD_LOGIC := '0';
	SHARED VARIABLE 	timer : integer;
	SHARED VARIABLE	cnt : integer;
	
BEGIN
	process
	BEGIN
		if (start = '1' and is_busy = '0') then
			cnt := 0;
			is_busy <= '1';
			busy <= '1';
			trigger <= '1';
			wait for 10500 ns;
			trigger <= '0';
			wait for 60000000 ns;
			is_busy <= '0';
			busy <= '0';
		end if;
	END process;
	
	process(clk)
	BEGIN
	
		if (rising_edge(clk)) then
			if (echo = '1') then
				cnt := cnt + 1;
			else
				data <= std_logic_vector(to_unsigned((cnt * 34) / 50000, 8));
				cnt := 0;
				busy <= '0';
				is_busy <= '0';
			end if;
		end if;
		
	END process;
END main;