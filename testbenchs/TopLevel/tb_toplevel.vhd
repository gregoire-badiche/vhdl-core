library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_toplevel is
end tb_toplevel;

architecture Behavioral of tb_toplevel is

    -- Component declaration
    component Arty_Digilent_TopLevel
        generic (
            N : integer := 8
        );
        Port (
            CLK100MHZ : in STD_LOGIC;
            sw        : in STD_LOGIC_VECTOR(3 downto 0);
            btn       : in STD_LOGIC_VECTOR(3 downto 0);
            led       : out STD_LOGIC_VECTOR(3 downto 0);
            led0_r : out STD_LOGIC; led0_g : out STD_LOGIC; led0_b : out STD_LOGIC;                
            led1_r : out STD_LOGIC; led1_g : out STD_LOGIC; led1_b : out STD_LOGIC;
            led2_r : out STD_LOGIC; led2_g : out STD_LOGIC; led2_b : out STD_LOGIC;                
            led3_r : out STD_LOGIC; led3_g : out STD_LOGIC; led3_b : out STD_LOGIC
        );
    end component;

    -- Signals
    signal CLK100MHZ : STD_LOGIC := '0';
    signal sw        : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal btn       : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal led       : STD_LOGIC_VECTOR(3 downto 0);

    signal led0_r, led0_g, led0_b : STD_LOGIC;
    signal led1_r, led1_g, led1_b : STD_LOGIC;
    signal led2_r, led2_g, led2_b : STD_LOGIC;
    signal led3_r, led3_g, led3_b : STD_LOGIC;

    constant CLK_PERIOD : time := 10 ns; -- 100 MHz

begin

    -- Instantiate DUT
    uut: Arty_Digilent_TopLevel
        port map (
            CLK100MHZ => CLK100MHZ,
            sw => sw,
            btn => btn,
            led => led,
            led0_r => led0_r, led0_g => led0_g, led0_b => led0_b,
            led1_r => led1_r, led1_g => led1_g, led1_b => led1_b,
            led2_r => led2_r, led2_g => led2_g, led2_b => led2_b,
            led3_r => led3_r, led3_g => led3_g, led3_b => led3_b
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
        wait for 50 ns;

        -- Test 1 : reset avec btn = "0001"
        btn <= "0001";
        sw <= "0011"; -- valeur arbitraire
        wait for 20 ns;
        btn <= "0000";

        wait for 200 ns;

        -- Test 2 : instruction 2
        btn <= "0010";
        wait for 20 ns;
        btn <= "0000";

        wait for 200 ns;

        -- Test 3 : instruction 6
        btn <= "0100";
        wait for 20 ns;
        btn <= "0000";

        wait for 200 ns;

        -- Fin simulation
        wait;
    end process;

end Behavioral;