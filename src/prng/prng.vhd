library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PRNG is
    generic (
        seed : std_logic_vector(3 downto 0) := "1011"
    );
    port (
        clk : in std_logic;
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

    signal started : std_logic := '0';
begin

    processor : entity work.processor
    generic map (
        N => N
    )
    port map (
        clk => clk,
        rst => p_rst,
        en => '1',

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

    main_proc : process(clk)
    begin
        if started = '0' then
            A_IN <= seed;
            rand <= seed;
            p_rst <= '1';
            started <= '1';
        else
            if falling_edge(clk) then
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