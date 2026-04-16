library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity memory is
generic (
    N_INSTR : integer := 128
);
port (
    clk : in std_logic;
    rst : in std_logic;
    en : in std_logic;

    instr_load : in unsigned(7 downto 0);

    instr_out : out std_logic_vector(9 downto 0)
);
end memory;

architecture memory_arch of memory is
    type mem_array is array (0 to N_INSTR-1) of std_logic_vector(9 downto 0);
    signal current_instr : unsigned(7 downto 0) := (others => '0');
    signal mem : mem_array := (
        -- f1
        0 =>    "0000000000", -- A <= A_in  ; nop
        1 =>    "1011000111", -- B <= B_in  ; mul
        -- f2
        2 =>    "0000000000", -- A <= A_in  ; nop
        3 =>    "1001000100", -- B <= B_in  ; add
        4 =>    "0111010000", -- B <= S     ; xor
        5 =>    "0100010011", -- B <= S     ; not B
        -- f3
        6 =>    "0001000000", -- A <= A_in  ; A
        7 =>    "1100011000", -- M1 <= S    ; rshift A
        8 =>    "0000001000", -- A <= S     ; nop
        9 =>    "0101000100", -- B <= B_in  ; and
        10 =>   "1110011100", -- M2 <= S    ; rshift B
        11 =>   "0000010000", -- B <= S     ; nop
        12 =>   "0101100000", -- A <= M1    ; and
        13 =>   "0000001000", -- A <= S     ; nop
        14 =>   "0110111011", -- B <= M2    ; or
        -- prng : X^4 + X^3 + 1
        15 =>   "0001000000", -- A <= A_IN  ; A
        16 =>   "1100011000", -- M1 <= S    ; rshift A
        17 =>   "1100001000", -- A <= S     ; rshift A
        18 =>   "1100001000", -- A <= S     ; rshift A
        19 =>   "0111010000", -- B <= S     ; xor
        20 =>   "1111001000", -- A <= S     ; lshift B
        21 =>   "1010010000", -- B <= S     ; sub       note : we CAN perform the sub here
        22 =>   "0000001000", -- A <= S     ; nop
        23 =>   "1111101000", -- B <= M1    ; lshift B
        24 =>   "1001010011", -- B <= S     ; add
        others => (others => '0')
    );
begin
    process(clk, rst)
    begin
        if rst = '1' then
            current_instr <= instr_load + 1;
            instr_out <= mem(to_integer(instr_load));
        elsif (falling_edge(clk) and en = '1') then
            current_instr <= current_instr + 1;
            instr_out <= mem(to_integer(current_instr));
        end if;
    end process;

end architecture;