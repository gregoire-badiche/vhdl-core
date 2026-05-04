library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity processor is
generic (
    N : integer := 8
);
port (
    clk : in std_logic;
    rst : in std_logic;
    en : in std_logic;

    A_IN : in std_logic_vector((N/2)-1 downto 0);
    B_IN : in std_logic_vector((N/2)-1 downto 0);
    SR_IN_L : in std_logic;
    SR_IN_R : in std_logic;

    RES_OUT : out std_logic_vector(N-1 downto 0);
    SR_OUT_L : out std_logic;
    SR_OUT_R : out std_logic;
    res_available : out std_logic;

    instr_load : in unsigned(7 downto 0)
);
end entity;

architecture processor_arch of processor is
    signal instr : std_logic_vector(9 downto 0);
begin
    mem : entity work.memory
    generic map (
        N_INSTR => 256
    )
    port map (
        clk => clk,
        rst => rst,
        en => en,
        instr_load => instr_load,
        instr_out => instr
    );

    core : entity work.core
    generic map (
        N => N
    )
    port map (
        clk => clk,
        rst => rst,
        en => en,
        SR_IN_L => SR_IN_L,
        SR_IN_R => SR_IN_R,
        A_IN => A_IN,
        B_IN => B_IN,
        INSTR_IN => instr,
        RES_OUT => RES_OUT,
        SR_OUT_L => SR_OUT_L,
        SR_OUT_R => SR_OUT_R,
        res_available => res_available
    );
end architecture;