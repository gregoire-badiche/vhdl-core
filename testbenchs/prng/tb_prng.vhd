library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_prng is
end tb_prng;

architecture Behavioral of tb_prng is
    constant CLK_PERIOD : time := 50 ns;
    -- Signals
    signal CLK100MHZ : STD_LOGIC := '0';
    signal rand : std_logic_vector(3 downto 0);
    signal rst : std_logic := '0';
begin

    -- Instantiate DUT
    prng: entity work.PRNG
        port map (
            clk => CLK100MHZ,
            rst => rst,
            en => '1',
            seed => "1101",
            rand => rand
        );

    -- Clock generation
    clk_process : process
    begin
        while true loop
            CLK100MHZ <= '0';
            wait for CLK_PERIOD/2;
            CLK100MHZ <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;

    m : process
    begin
        rst <= '1';
        wait for 110 ns;
        rst <= '0';
        wait for 500 us;
        rst <= '1';
        wait for 110 ns;
        rst <= '0';
        wait;
    end process;

end Behavioral;