LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


entity tele is
	port(  
		clk		:	IN		STD_LOGIC;										--system clock
		reset_n	:	IN		STD_LOGIC;										--ascynchronous reset
		--tx_ena	:	IN		STD_LOGIC;										--initiate transmission
		--tx_data	:	IN		STD_LOGIC_VECTOR(7 DOWNTO 0);  --data to transmit from switches for part 1
		rx			:	IN		STD_LOGIC;			--receive pin
		echo		: 	IN 	STD_LOGIC;
		rx_busy	:	OUT	STD_LOGIC;										--data reception in progress
		rx_error	:	OUT	STD_LOGIC;										--start, parity, or stop bit error detected
		rx_led_1	:	OUT	STD_LOGIC_VECTOR(0 to 6);	--data received
		rx_led_0	:	OUT	STD_LOGIC_VECTOR(0 to 6);	--data received
		tx_busy	:	OUT	STD_LOGIC; 		--transmission in progress
		trigger 	: 	OUT		STD_LOGIC;
		tx			:	OUT	STD_LOGIC);
end entity tele;

architecture behaviour of tele is
	type t_tele_state is(idle, starting, running, feedback);
	signal tele_data : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal rx_data : STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal start_tele : std_logic;
	signal tele_busy : std_logic;
	signal cnt : std_logic_vector(21 downto 0);
	signal rst_cnt : std_logic := '1';
	signal tx_data : std_logic_vector(7	downto 0);
	signal tx_ena : std_logic;
	signal rst : std_logic;
	signal rx_busy_cus : std_logic;
	signal power_tele : std_logic;
	signal data_1 : std_logic_vector(7 downto 0);
	signal data_2 : std_logic_vector(7 downto 0);
	signal data_3 : std_logic_vector(7 downto 0);
begin
	
	tele_instance : entity work.telemeter PORT MAP(
		clk => clk,
		start => start_tele,
		busy => tele_busy,
		trigger => trigger,
		echo => echo,
		data => tele_data
	);
	
	uart_instance : entity work.uart PORT MAP (
      clk => clk,
		reset_n => reset_n,
		tx_ena => tx_ena,
		tx_data => tx_data,
		rx => rx,
		rx_busy => rx_busy_cus,
		rx_error => rx_error,
		rx_data => rx_data,
		tx_busy => tx_busy,
		tx => tx);
		
	process(tele_data)
		variable convertion : integer;
		variable lim1, lim2, lim3 : integer;
	begin
		convertion := to_integer(unsigned(tele_data));
		lim1 := convertion / 100;
		lim2 := (convertion / 10) mod 10;
		lim3 := convertion mod 10;
		if (convertion > 999) then
			data_1 <= "01000110";
			data_2 <= "01000110";
			data_3 <= "01000110";
		else
			case lim1 is 
				when 0 => data_1 <= "00110000";
				when 1 => data_1 <= "00110001";
				when 2 => data_1 <= "00110010";
				when 3 => data_1 <= "00110011";
				when 4 => data_1 <= "00110100";
				when 5 => data_1 <= "00110101";
				when 6 => data_1 <= "00110110";
				when 7 => data_1 <= "00110111";
				when 8 => data_1 <= "00111000";
				when 9 => data_1 <= "00111001";
				when others => data_1 <= "00110000";
			end case;
			case lim2 is 
				when 0 => data_2 <= "00110000";
				when 1 => data_2 <= "00110001";
				when 2 => data_2 <= "00110010";
				when 3 => data_2 <= "00110011";
				when 4 => data_2 <= "00110100";
				when 5 => data_2 <= "00110101";
				when 6 => data_2 <= "00110110";
				when 7 => data_2 <= "00110111";
				when 8 => data_2 <= "00111000";
				when 9 => data_2 <= "00111001";
				when others => data_2 <= "00110000";
			end case;
			case lim3 is 
				when 0 => data_3 <= "00110000";
				when 1 => data_3 <= "00110001";
				when 2 => data_3 <= "00110010";
				when 3 => data_3 <= "00110011";
				when 4 => data_3 <= "00110100";
				when 5 => data_3 <= "00110101";
				when 6 => data_3 <= "00110110";
				when 7 => data_3 <= "00110111";
				when 8 => data_3 <= "00111000";
				when 9 => data_3 <= "00111001";
				when others => data_3 <= "00110000";
			end case;
		end if;
	end process;
		
	
	process(rx_data)
	begin
		case rx_data(7 downto 4) is -- conf 1 / displaying uart in hexa on 7 segments displays
			when "0000"=> rx_led_1 <="0000001";  -- '0'
			when "0001"=> rx_led_1 <="1001111";  -- '1'
			when "0010"=> rx_led_1 <="0010010";  -- '2'
			when "0011"=> rx_led_1 <="0000110";  -- '3'
			when "0100"=> rx_led_1 <="1001100";  -- '4' 
			when "0101"=> rx_led_1 <="0100100";  -- '5'
			when "0110"=> rx_led_1 <="0100000";  -- '6'
			when "0111"=> rx_led_1 <="0001111";  -- '7'
			when "1000"=> rx_led_1 <="0000000";  -- '8'
			when "1001"=> rx_led_1 <="0000100";  -- '9'
			when "1010"=> rx_led_1 <="0001000";  -- 'A'
			when "1011"=> rx_led_1 <="1100000";  -- 'b'
			when "1100"=> rx_led_1 <="0110001";  -- 'C'
			when "1101"=> rx_led_1 <="1000010";  -- 'd'
			when "1110"=> rx_led_1 <="0110000";  -- 'E'
			when "1111"=> rx_led_1 <="0111000";  -- 'F'
			when others =>  NULL;
		end case;
		case rx_data(3 downto 0) is
			when "0000"=> rx_led_0 <="0000001";  -- '0'
			when "0001"=> rx_led_0 <="1001111";  -- '1'
			when "0010"=> rx_led_0 <="0010010";  -- '2'
			when "0011"=> rx_led_0 <="0000110";  -- '3'
			when "0100"=> rx_led_0 <="1001100";  -- '4' 
			when "0101"=> rx_led_0 <="0100100";  -- '5'
			when "0110"=> rx_led_0 <="0100000";  -- '6'
			when "0111"=> rx_led_0 <="0001111";  -- '7'
			when "1000"=> rx_led_0 <="0000000";  -- '8'
			when "1001"=> rx_led_0 <="0000100";  -- '9'
			when "1010"=> rx_led_0 <="0001000";  -- 'A'
			when "1011"=> rx_led_0 <="1100000";  -- 'b'
			when "1100"=> rx_led_0 <="0110001";  -- 'C'
			when "1101"=> rx_led_0 <="1000010";  -- 'd'
			when "1110"=> rx_led_0 <="0110000";  -- 'E'
			when "1111"=> rx_led_0 <="0111000";  -- 'F'
			when others =>  NULL;
		end case;
	end process;
	process(clk, rst)
		type data_sent is(dat_1, dat_2, dat_3);
		variable tele_curr_state: t_tele_state := idle;
		variable counter: integer;
		variable data_to_send:data_sent := dat_1;
	begin
		if (rst = '0' and tele_curr_state = idle) then
			power_tele <= '0';
			tx_ena <= '1';
		elsif(clk'event and clk='1') then
			if (rx_data(7 downto 0) = "01110110") then
				case tele_curr_state is
					when idle =>
						power_tele <= '1';
						counter := 0;
						tx_ena <= '1';
						tele_curr_state := starting;
					when starting =>
						counter := counter + 1;
						if (counter > 200) then
							power_tele <= '0';
							counter := 0;
							tele_curr_state := running;
						end if;
					when running =>
						if (tele_busy = '0') then
							counter := 0;
							tele_curr_state := feedback;
						end if;
					when feedback =>
						counter := counter + 1;
						if (counter < 60000) then
							tx_data <= data_1;
						elsif (counter < 120000) then
							tx_data <= data_2;
						elsif (counter < 180000) then
							tx_data <= data_3;
						elsif (counter < 240000) then
							tx_data <= "00001101";
						elsif (counter < 300000) then
							tx_data <= "00001010";
						elsif (counter > 5000000) then
							tele_curr_state := idle;
						end if;
						if ((counter mod 60000) < 50 and counter < 300000) then
							tx_ena <= '0';
						else
							tx_ena <= '1';
						end if;
				end case;
			else
				power_tele <= '0';
				tx_ena <= '1';
			end if;
		end if;
		
		
	end process;
	--rx_busy <= rst;
	start_tele <= power_tele;
	rx_busy <= rx_busy_cus;
	rst <= rx_busy_cus;
end behaviour;