library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity UAL is
generic (
    N : integer := 8;
    INSTR_S : integer := 4
);
port (
    SEL_FCT : in std_logic_vector(INSTR_S-1 downto 0);
    Buffer_A : in std_logic_vector((N/2)-1 downto 0);
    Buffer_B : in std_logic_vector((N/2)-1 downto 0);
    SR_IN_L : in std_logic;
    SR_IN_R : in std_logic;

    S : out std_logic_vector(N-1 downto 0);
    SR_OUT_L : out std_logic;
    SR_OUT_R : out std_logic
);
end UAL;

architecture UAL_arch of UAL is
    signal A : std_logic_vector(N-1 downto 0);
    signal B : std_logic_vector(N-1 downto 0);
    -- signal L : std_logic_vector(N-1 downto 0);
    signal R : std_logic_vector(N-1 downto 0);
begin
    A(N-1 downto (N/2)) <= (others => Buffer_A((N/2)-1));
    A((N/2)-1 downto 0) <= Buffer_A;

    B(N-1 downto (N/2)) <= (others => Buffer_B((N/2)-1));
    B((N/2)-1 downto 0) <= Buffer_B;

    -- L <= (0 => SR_IN_L, others => '0');
    R <= (0 => SR_IN_R, others => '0');

    main : process(all)
    begin
        S <= (others => '0');
        SR_OUT_L <= '0';
        SR_OUT_R <= '0';

        case SEL_FCT is
            when "0000" => 
                null;
            when "0001" => 
                S <= A;
            when "0010" => 
                S <= not A;
            when "0011" => 
                S <= B;
            when "0100" => 
                S <= not B;
            when "0101" => 
                S <= A and B;
            when "0110" => 
                S <= A or B;
            when "0111" => 
                S <= A xor B;
            when "1000" => 
                S <= A + B + R;
            when "1001" =>
                S <= A + B;
            when "1010" =>
                S <= A - B;
            when "1011" =>
                S <= std_logic_vector(signed(Buffer_A) * signed(Buffer_B));
            when "1100" =>
                SR_OUT_R <= Buffer_A(0);
                S(((N/2)-2) downto 0) <= Buffer_A(((N/2)-1) downto 1);
                S(N-1) <= SR_IN_L;
            when "1101" =>
                SR_OUT_L <= Buffer_A((N/2)-1);
                S(((N/2)-1) downto 1) <= Buffer_A(((N/2)-2) downto 0);
                S(0) <= SR_IN_R;
            when "1110" =>
                SR_OUT_R <= Buffer_B(0);
                S(((N/2)-2) downto 0) <= Buffer_B(((N/2)-1) downto 1);
                S(N-1) <= SR_IN_L;
            when "1111" =>
                SR_OUT_L <= Buffer_B((N/2)-1);
                S(((N/2)-1) downto 1) <= Buffer_B(((N/2)-2) downto 0);
                S(0) <= SR_IN_R;
            when others =>
                null;
        end case;
    end process;

end architecture;