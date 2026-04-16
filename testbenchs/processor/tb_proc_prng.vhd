library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity tb_proc_prng is
end entity;

architecture impl of tb_proc_prng is
    constant PERIOD : time := 50 us;
    constant N : integer := 8;
    constant N_ITER : integer := 200;

    signal clk : std_logic;
    signal rst : std_logic := '1';
    signal en : std_logic;
    signal A_IN : std_logic_vector((N/2)-1 downto 0) := "1011";
    signal B_IN : std_logic_vector((N/2)-1 downto 0) := "0000";
    signal SR_IN_L : std_logic := '0';
    signal SR_IN_R : std_logic := '0';

    signal RES_OUT : std_logic_vector(N-1 downto 0);
    signal SR_OUT_L : std_logic;
    signal SR_OUT_R : std_logic;

    signal res_available : std_logic;
    signal instr_load : unsigned(7 downto 0) := to_unsigned(15, 8);

    -- signal is_setup : std_logic := '0';
    signal rand : std_logic_vector(3 downto 0) := (others => '0');

begin

    processor : entity work.processor
    generic map (
        N => N
    )
    port map (
        clk => clk,
        rst => rst,
        en => en,

        A_IN => A_IN,
        B_IN => B_IN,
        SR_IN_L => SR_IN_L,
        SR_IN_R => SR_IN_R,
        SR_OUT_L => SR_OUT_L,
        SR_OUT_R => SR_OUT_R,

        RES_OUT => RES_OUT,

        res_available => res_available,
        instr_load => instr_load
    );

    en <= '1';
    instr_load <= to_unsigned(15, 8);

    clock_proc : process
    begin
        for i in 0 to N_ITER loop
            clk <= '0';
            wait for PERIOD/2;
            clk <= '1';
            wait for PERIOD/2;
        end loop;
        wait;
    end process;

    -- begin_proc : process(all)
    -- begin
    --     if is_setup = '0' then
    --         rst <= '1';
    --         A_IN <= "1011";
    --         is_setup <= '1';
    --     end if;
    -- end process;

    main_proc : process(clk)
    begin
        if falling_edge(clk) then
            if rst = '1' then
                rst <= '0';
            end if;
            if res_available = '1' then
                A_IN <= RES_OUT((N/2)-1 downto 0);
                rand <= RES_OUT((N/2)-1 downto 0);
                rst <= '1';
            end if;
        end if;
    end process;

end architecture;
