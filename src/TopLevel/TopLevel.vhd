library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Arty_Digilent_TopLevel is
    generic (
        N : integer := 8
    );
    Port (
        CLK100MHZ : in STD_LOGIC;
        sw        : in STD_LOGIC_VECTOR(3 downto 0);
        btn       : in STD_LOGIC_VECTOR(3 downto 0);
        led       : out STD_LOGIC_VECTOR(3 downto 0);
        led0_r : out STD_LOGIC; led0_g : out STD_LOGIC; led0_b : out STD_LOGIC;                
        led1_r : out STD_LOGIC; led1_g : out STD_LOGIC; led1_b : out STD_LOGIC;
        led2_r : out STD_LOGIC; led2_g : out STD_LOGIC; led2_b : out STD_LOGIC;                
        led3_r : out STD_LOGIC; led3_g : out STD_LOGIC; led3_b : out STD_LOGIC
    );
end Arty_Digilent_TopLevel;

architecture Behavioral of Arty_Digilent_TopLevel is
    signal rst : std_logic := '1';
    signal en : std_logic;
    signal A_IN : std_logic_vector(3 downto 0);
    signal B_IN : std_logic_vector(3 downto 0);
    signal SR_IN_L : std_logic;
    signal SR_IN_R : std_logic;

    signal RES_OUT : std_logic_vector(7 downto 0);
    signal SR_OUT_L : std_logic;
    signal SR_OUT_R : std_logic;

    signal res_available : std_logic;
    signal instr_load : unsigned(7 downto 0) := to_unsigned(0, 8);

    signal result : std_logic_vector(7 downto 0) := (others => '0');
    signal res_available_mem : std_logic := '0';
begin

    processor : entity work.processor
    generic map (
        N => N
    )
    port map (
        clk => CLK100MHZ,
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

    btn_proc : process(CLK100MHZ)
    begin
        if falling_edge(CLK100MHZ) then
            case btn is
                when "0001" =>
                    rst <= '1';
                    instr_load <= to_unsigned(0, 8);
                    res_available_mem <= '0';
                when "0010" =>
                    rst <= '1';
                    instr_load <= to_unsigned(2, 8);
                    res_available_mem <= '0';
                when "0100" =>
                    rst <= '1';
                    instr_load <= to_unsigned(6, 8);
                    res_available_mem <= '0';
                when others =>
                    rst <= '0';
            end case;
            if (res_available = '1' and res_available_mem = '0') then
                rst <= '1';
                result <= RES_OUT;
                res_available_mem <= '1';
            end if;
        end if;
    end process;

    led <= result(3 downto 0);
    A_IN <= sw;
    B_IN <= sw;
    SR_IN_L <= '0';
    SR_IN_R <= '0';

    -- Mise à 0 des leds de couleurs RGB
    led0_r <= '0'; led0_g <= '0'; led0_b <= '0';
    led1_r <= '0'; led1_g <= '0'; led1_b <= '0';
    led2_r <= '0'; led2_g <= '0'; led2_b <= '0';
    led3_r <= '0'; led3_g <= '0'; led3_b <= '0';
    
end Behavioral;