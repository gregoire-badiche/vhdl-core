library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PRNG is
    port (
        clk : in std_logic;
        rst : in std_logic;
        en : in std_logic;
        seed : in std_logic_vector(3 downto 0);
        rand : out std_logic_vector(3 downto 0)
    );
end PRNG;

architecture PRNG_arch of PRNG is
    constant N : integer := 8;
    signal A_IN : std_logic_vector(3 downto 0) := (others => '0');
    signal B_IN : std_logic_vector(3 downto 0) := (others => '0');
    signal SR_OUT_L : std_logic;
    signal SR_OUT_R : std_logic;
    signal RES_OUT : std_logic_vector(7 downto 0);
    signal instr_load : unsigned(7 downto 0) := to_unsigned(15, 8);
    signal p_rst : std_logic := '1';
    signal res_available : std_logic;
begin

    processor : entity work.processor
    generic map (
        N => N
    )
    port map (
        clk => clk,
        rst => p_rst,
        en => en,

        A_IN => A_IN,
        B_IN => B_IN,
        SR_IN_L => '0',
        SR_IN_R => '0',
        SR_OUT_L => SR_OUT_L,
        SR_OUT_R => SR_OUT_R,

        RES_OUT => RES_OUT,

        res_available => res_available,
        instr_load => instr_load
    );

    main_proc : process(clk, rst)
    begin
        if rst = '1' then
            A_IN <= seed;
            rand <= seed;
            p_rst <= '1';
        else
            if falling_edge(clk) and en = '1' then
                if p_rst = '1' then
                    p_rst <= '0';
                end if;
                if res_available = '1' then
                    A_IN <= RES_OUT((N/2)-1 downto 0);
                    rand <= RES_OUT((N/2)-1 downto 0);
                    p_rst <= '1';
                end if;
            end if;
        end if;
    end process;
    
end PRNG_arch;