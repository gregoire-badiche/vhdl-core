library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity tb_proc_result is
end entity;

architecture impl of tb_proc_result is
    constant PERIOD : time := 50 us;
    constant N : integer := 8;
    constant N_ITER : integer := 12;

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
        en => not res_available,

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

    instr_load <= to_unsigned(2, 8);

    clock_proc : process
    begin
        rst <= '1';
        A_IN <= std_logic_vector(to_signed(2, 4));
        B_IN <= std_logic_vector(to_signed(3, 4));
        SR_IN_L <= '0';
        SR_IN_R <= '0';
        clk <= '0';
        wait for PERIOD/2;
        rst <= '0';
        for i in 0 to N_ITER loop
            clk <= '0';
            wait for PERIOD/2;
            clk <= '1';
            wait for PERIOD/2;
        end loop;

        assert (res_out(3 downto 0) = (std_logic_vector(signed(A_IN) + signed(B_IN)) xnor A_IN))
        report "res_out=" & to_string(res_out(3 downto 0)) &
            " | expected=" & to_string(std_logic_vector(signed(A_IN) + signed(B_IN)) xnor A_IN)
        severity error;

        rst <= '1';
        wait for PERIOD/2;
        rst <= '0';
        for i in 0 to N_ITER loop
            clk <= '0';
            wait for PERIOD/2;
            clk <= '1';
            wait for PERIOD/2;
        end loop;
        assert (res_out(3 downto 0) = (std_logic_vector(signed(A_IN) + signed(B_IN)) xnor A_IN))
        report "res_out=" & to_string(res_out(3 downto 0)) &
            " | expected=" & to_string(std_logic_vector(signed(A_IN) + signed(B_IN)) xnor A_IN)
        severity error;

        wait;
    end process;

end architecture;
