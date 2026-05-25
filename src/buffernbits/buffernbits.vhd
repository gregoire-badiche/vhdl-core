library IEEE;
use IEEE.std_logic_1164.all;

entity bufferNbits is
generic (
    N : integer := 8
);
port (
    clk : in std_logic;
    en : in std_logic;
    rst : in std_logic;
    e1 : in std_logic_vector (N-1 downto 0);
    s1 : out std_logic_vector (N-1 downto 0) := (others => '0')
);
end bufferNbits;

architecture bufferNbits_Arch of bufferNbits is

begin
    proc: process (clk, rst)
    begin
        if rst = '1' then
            s1 <= (others => '0');
        elsif (rising_edge(clk) and en = '1') then
            s1 <= e1;
        end if;
    end process;
end bufferNbits_Arch;