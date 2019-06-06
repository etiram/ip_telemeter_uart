LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity tele is
	port(  
		clk		:	IN		STD_LOGIC;										--system clock
		reset_n	:	IN		STD_LOGIC;										--ascynchronous reset
		tx_ena	:	IN		STD_LOGIC;										--initiate transmission
		tx_data	:	IN		STD_LOGIC_VECTOR(7 DOWNTO 0);  --data to transmit
		rx			:	IN		STD_LOGIC;										--receive pin
		rx_busy	:	OUT	STD_LOGIC;										--data reception in progress
		rx_error	:	OUT	STD_LOGIC;										--start, parity, or stop bit error detected
		rx_led_1	:	OUT	STD_LOGIC_VECTOR(0 to 6);	--data received
		rx_led_0	:	OUT	STD_LOGIC_VECTOR(0 to 6);	--data received
		tx_busy	:	OUT	STD_LOGIC;  									--transmission in progress
		tx			:	OUT	STD_LOGIC);
end entity tele;

architecture behaviour of tele is
	signal rx_data : STD_LOGIC_VECTOR(7 DOWNTO 0);
begin
	
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
		
	process(rx_data)
	begin
		case rx_data(7 downto 4) is
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
end behaviour;