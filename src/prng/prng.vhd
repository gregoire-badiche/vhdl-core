library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PRNG is
    port (
        clk : in std_logic;
        rst : in std_logic;
        en : in std_logic;
        compute_next : in std_logic;
        seed : in std_logic_vector(3 downto 0);
        rand_out : out std_logic_vector(3 downto 0);
        res_available : out std_logic
    );
end PRNG;

architecture PRNG_arch of PRNG is
    constant N : integer := 8;
    signal A_IN : std_logic_vector(3 downto 0) := (others => '0');
    signal B_IN : std_logic_vector(3 downto 0) := (others => '0');
    signal SR_OUT_L : std_logic;
    signal SR_OUT_R : std_logic;
    signal instr_load : unsigned(7 downto 0) := to_unsigned(15, 8);
    signal processor_out : std_logic_vector(7 downto 0);
    signal processor_rst : std_logic := '1';
    signal has_computed : std_logic := '0';
    signal has_been_init : std_logic := '0';
begin

    processor : entity work.processor
    generic map (
        N => N
    )
    port map (
        clk => clk,
        rst => processor_rst,
        en => en,

        A_IN => A_IN,
        B_IN => B_IN,
        SR_IN_L => '0',
        SR_IN_R => '0',
        SR_OUT_L => SR_OUT_L,
        SR_OUT_R => SR_OUT_R,

        RES_OUT => processor_out,

        res_available => res_available,
        instr_load => instr_load
    );

    rng_proc : process(clk, rst)
    begin
        if rst = '1' or has_been_init = '0' then
            processor_rst <= '1';
            rand_out <= seed;
            A_IN <= seed;
            has_computed <= '0';
            has_been_init <= '1';
        else
            if falling_edge(clk) then
                if compute_next = '1' then
                    has_computed <= '0';
                end if;
                if processor_rst = '1' and has_computed = '0' then
                    processor_rst <= '0';
                end if;
                if res_available = '1' then
                    A_IN <= processor_out(3 downto 0);
                    rand_out <= processor_out(3 downto 0);
                    processor_rst <= '1';
                    has_computed <= '1';
                end if;
            end if;
        end if;
        
    end process;
    
end PRNG_arch;