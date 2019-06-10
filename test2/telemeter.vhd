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
	signal state : tele_state := idle;
	signal cnt : std_logic_vector(21 downto 0);
	signal rst_cnt : std_logic := '1';
	
BEGIN
	counter_inst : entity work.counter GENERIC MAP (
		n => 22)
	PORT MAP (
		clk => clk,
		reset => rst_cnt,
		output => cnt);
	process(start, echo, state, cnt)
		variable curr_val : integer := 0;
	BEGIN
		CASE state IS
			WHEN idle =>
				if (start = '1') then
					busy <= '1';
					state <= sending;
					rst_cnt <= '0';
				end if;
			WHEN sending =>
				trigger <= '1';
				if (unsigned(cnt) > 525) then
					trigger <= '0';
					rst_cnt <= '1';
					state <= waiting;
				end if;
			WHEN waiting =>
				if (echo = '1') then
					rst_cnt <= '0';
					state <= receiving;
				end if;
			WHEN receiving =>
				if (echo = '0') then
					curr_val := to_integer((unsigned(cnt) * 34) / 50000);
					data <= std_logic_vector(to_unsigned(curr_val, 16));
					rst_cnt <= '1';
					state <= reset;
				end if;
			WHEN reset =>
				rst_cnt <= '0';
				if (unsigned(cnt) >= 3000000) then
					rst_cnt <= '1';
					state <= idle;
					busy <= '0';
				end if;
		END CASE;
	END process;
END main;