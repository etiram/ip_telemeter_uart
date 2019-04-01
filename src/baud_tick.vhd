entity basic_uart is
  port (
    clk: in std_logic;                         -- clock
    reset: in std_logic;                       -- reset
  );
end basic_uart;

architecture Behavioral of basic_uart is
  constant DIVISOR : natural := 326;
  constant COUNTER_BITS : natural := integer(ceil(log2(real(DIVISOR))));
  signal sample: std_logic; -- 1 clk spike at 16x baud rate
  signal sample_counter: std_logic_vector(COUNTER_BITS-1 downto 0); -- should fit values in 0..DIVISOR-1

begin

  -- sample signal at 16x baud rate, 1 CLK spikes
  sample_process: process (clk,reset) is
  begin
    if reset = '1' then
      sample_counter <= (others => '0');
      sample <= '0';
    elsif rising_edge(clk) then
      if sample_counter = DIVISOR-1 then
        sample <= '1';
        sample_counter <= (others => '0');
      else
        sample <= '0';
        sample_counter <= sample_counter + 1;
      end if;
    end if;
  end process;

end Behavioral;
