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
	type t_tele_state is(idle, running);
	signal tele_data : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal rx_data : STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal start_tele : std_logic := '0';
	signal tele_busy : std_logic;
	signal tele_state : t_tele_state := idle;
	signal cnt : std_logic_vector(21 downto 0);
	signal rst_cnt : std_logic := '1';
	signal tx_data : std_logic_vector(7 downto 0);
	signal tx_ena : std_logic := '0';
begin

	counter_inst : entity work.counter GENERIC MAP (
		n => 22)
	PORT MAP (
		clk => clk,
		reset => rst_cnt,
		output => cnt);
	
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
		rx_busy => rx_busy,
		rx_error => rx_error,
		rx_data => rx_data,
		tx_busy => tx_busy,
		tx => tx);
		
	process(rx_data, tele_state, tele_busy)	
	begin
		if (rx_data = "01010001" and tele_state = idle) then
			start_tele <= '1';
			tele_state <= running;
		elsif (tele_state = running and start_tele = '1') then
			start_tele <= '0';
		elsif (tele_state = running and tele_busy = '0') then
			rst_cnt <= '0';
			tx_ena <= '1';
			if (unsigned(cnt) < 200) then
				tx_data <= tele_data(15 downto 8);
			elsif (unsigned(cnt) < 400) then
				tx_data <= tele_data(7 downto 0);
			elsif (unsigned(cnt) < 600) then
				tx_data <= "00001010";
			else
				rst_cnt <= '0';
				tx_ena <= '0';
				tele_state <= idle;
			end if;
		end if;
		
		case tele_data(7 downto 4) is -- conf 1 / displaying uart in hexa on 7 segments displays
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
		case tele_data(3 downto 0) is
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
end behaviour;