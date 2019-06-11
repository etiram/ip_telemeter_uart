LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.NUMERIC_STD.ALL;

ENTITY telemeter IS
	PORT(
		start 	: 	IN		STD_LOGIC;
		echo		: 	IN		STD_LOGIC;
		clk		: 	IN		STD_LOGIC;
		data		:	OUT	STD_LOGIC_VECTOR(15 downto 0);
		busy		:	OUT	STD_LOGIC;
		trigger	:	OUT	STD_LOGIC);
END telemeter;

architecture main of telemeter IS
	type tele_state is(idle, sending, waiting, receiving, reset);
	
BEGIN
	process(clk)
		variable curr_val : integer;
		variable curr_state : tele_state := idle;
		variable cnt : integer;
	BEGIN
		if (start = '0' and curr_state = idle) then
			busy <= '0';
		elsif (clk'event and clk = '1') then
			CASE curr_state IS
				WHEN idle =>
					cnt := 0;
					curr_state := sending;
				WHEN sending =>
					busy <= '1';
					trigger <= '1';
					cnt := cnt + 1;
					if (cnt > 525) then
						trigger <= '0';
						curr_state := waiting;
					end if;
				WHEN waiting =>
					cnt := 0;
					if (echo = '1') then
						curr_state := receiving;
					end if;
				WHEN receiving =>
					cnt := cnt + 1;
					if (echo = '0') then
						curr_val := (cnt * 34) / 100000;
						data <= std_logic_vector(to_unsigned(curr_val, 16));
						curr_state := reset;
					end if;
				WHEN reset =>
					cnt := cnt + 1;
					if (cnt >= 3000000) then
						cnt := 0;
						curr_state := idle;
						busy <= '0';
					end if;
			END CASE;
		end if;
	END process;
END main;