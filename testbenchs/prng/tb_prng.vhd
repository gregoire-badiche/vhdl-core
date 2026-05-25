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
begin

    -- Instantiate DUT
    prng: entity work.PRNG
        generic map (
            seed => "1101"
        )
        port map (
            clk => CLK100MHZ,
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

end Behavioral;