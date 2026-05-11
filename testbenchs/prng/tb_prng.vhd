library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_prng is
end tb_prng;

architecture Behavioral of tb_prng is
    constant CLK_PERIOD : time := 50 ns;
    -- Signals
    signal CLK100MHZ : STD_LOGIC := '0';
    signal n : std_logic := '0';
    signal rand : std_logic_vector(3 downto 0);
    signal res_available : std_logic;
    signal rst2 : std_logic;
begin

    -- Instantiate DUT
    prng: entity work.PRNG
        port map (
            clk => CLK100MHZ,
            rst => rst2,
            en => '1',
            compute_next => n,
            seed => "1101",
            rand_out => rand,
            res_available => res_available
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

    -- Stimulus process
    stim_proc : process
    begin
        -- Initial wait
        
        wait for 1000 ns;

        -- Test 3 : instruction 6
        n <= '1';
        wait for 50 ns;
        n <= '0';

        wait for 1000 ns;

        n <= '1';
        wait for 50 ns;
        n <= '0';

        wait for 1000 ns;

        -- Test 3 : instruction 6
        n <= '1';
        wait for 50 ns;
        n <= '0';

        wait for 1000 ns;

        n <= '1';
        wait for 50 ns;
        n <= '0';

        wait for 1000 ns;

        -- Test 3 : instruction 6
        n <= '1';
        wait for 50 ns;
        n <= '0';

        wait for 1000 ns;

        rst2 <= '1';
        wait for 110 ns;
        rst2 <= '0';

        wait for 1000 ns;

        -- Test 3 : instruction 6
        n <= '1';
        wait for 50 ns;
        n <= '0';

        wait for 1000 ns;

        n <= '1';
        wait for 50 ns;
        n <= '0';

        wait for 1000 ns;

        -- Test 3 : instruction 6
        n <= '1';
        wait for 50 ns;
        n <= '0';

        wait for 1000 ns;

        n <= '1';
        wait for 50 ns;
        n <= '0';

        wait for 1000 ns;

        -- Test 3 : instruction 6
        n <= '1';
        wait for 50 ns;
        n <= '0';

        wait for 1000 ns;

        -- Fin simulation
        wait;
    end process;

end Behavioral;