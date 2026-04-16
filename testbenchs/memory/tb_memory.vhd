library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity tb_memory is
end entity;

architecture tb of tb_memory is
    constant PERIOD : time := 50 us;
    constant N : integer := 4;
    constant N_ITER : integer := 20;

    signal clk : std_logic;
    signal rst : std_logic;
    signal en : std_logic;

    signal instr_load : unsigned(7 downto 0);
    signal instr_out : std_logic_vector(9 downto 0);
begin
    mem : entity work.memory
    generic map (
        N_INSTR => 128
    )
    port map (
        clk => clk,
        rst => rst,
        en => en,
        instr_load => instr_load,
        instr_out => instr_out
    );

    en <= '1';
    rst <= '0';
    instr_load <= (others => '0');

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

end architecture;