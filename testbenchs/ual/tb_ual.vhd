library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- library work;

entity tb_ual is
end entity;

architecture tb of tb_ual is
    constant N : integer := 8;
    constant INSTR_S : integer := 4;

    -- Signaux TB
    signal SEL_FCT : std_logic_vector(INSTR_S-1 downto 0);
    signal Buffer_A : std_logic_vector((N/2)-1 downto 0);
    signal Buffer_B : std_logic_vector((N/2)-1 downto 0);
    signal SR_IN_L : std_logic := '0';
    signal SR_IN_R : std_logic := '0';

    signal S : std_logic_vector(N-1 downto 0);
    signal SR_OUT_L : std_logic;
    signal SR_OUT_R : std_logic;
begin
    ual : entity work.UAL
    generic map (
        N => N,
        INSTR_S => INSTR_S
    )
    port map (
        SEL_FCT => SEL_FCT,
        Buffer_A => Buffer_A,
        Buffer_B => Buffer_B,
        SR_IN_L => SR_IN_L,
        SR_IN_R => SR_IN_L,

        S => S,
        SR_OUT_L => SR_OUT_L,
        SR_OUT_R => SR_OUT_R
    );

    stim_proc : process
    begin
        Buffer_A <= "0011";
        Buffer_B <= "1010";
        SR_IN_L <= '0';
        SR_IN_R <= '1';

        SEL_FCT <= "0000";
        wait for 10 ns;

        SEL_FCT <= "0001";
        wait for 10 ns;

        SEL_FCT <= "0010";
        wait for 10 ns;

        SEL_FCT <= "0011";
        wait for 10 ns;

        SEL_FCT <= "0100";
        wait for 10 ns;

        SEL_FCT <= "0101";
        wait for 10 ns;

        SEL_FCT <= "0110";
        wait for 10 ns;

        SEL_FCT <= "0111";
        wait for 10 ns;

        SEL_FCT <= "1000";
        wait for 10 ns;

        SEL_FCT <= "1001";
        wait for 10 ns;

        SEL_FCT <= "1010";
        wait for 10 ns;

        SEL_FCT <= "1011";
        wait for 10 ns;

        SEL_FCT <= "1100";
        wait for 10 ns;

        SEL_FCT <= "1101";
        wait for 10 ns;

        SEL_FCT <= "1110";
        wait for 10 ns;

        SEL_FCT <= "1111";
        wait for 10 ns;

        wait;
    end process;

end architecture;