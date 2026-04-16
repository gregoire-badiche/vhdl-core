library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity tb_proc_f3 is
end entity;

architecture impl of tb_proc_f3 is
    constant PERIOD : time := 50 us;
    constant N : integer := 8;
    constant N_ITER : integer := 9;

    signal clk : std_logic;
    signal rst : std_logic;
    signal en : std_logic;
    signal A_IN : std_logic_vector((N/2)-1 downto 0);
    signal B_IN : std_logic_vector((N/2)-1 downto 0);
    signal SR_IN_L : std_logic;
    signal SR_IN_R : std_logic;

    signal RES_OUT : std_logic_vector(N-1 downto 0);
    signal SR_OUT_L : std_logic;
    signal SR_OUT_R : std_logic;

    signal res_available : std_logic;
    signal instr_load : unsigned(7 downto 0);

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
    instr_load <= to_unsigned(6, 8);

    clock_proc : process
    begin
        for a in 0 to 3 loop
            for b in 0 to 3 loop
                rst <= '1';
                A_IN <= std_logic_vector(to_signed(a, 4));
                B_IN <= std_logic_vector(to_signed(b, 4));
                SR_IN_L <= '0';
                SR_IN_R <= '0';
                clk <= '0';
                wait for PERIOD/2;
                rst <= '0';
                for i in 0 to 8 loop
                    clk <= '0';
                    wait for PERIOD/2;
                    clk <= '1';
                    wait for PERIOD/2;
                end loop;
                assert (res_out(0) = ((A_in(0) and B_in(1)) or (A_in(1) and B_in(0)))) report "megabruh" severity error;
                wait for 2*PERIOD;
            end loop;
        end loop;

        wait;
    end process;

end architecture;
