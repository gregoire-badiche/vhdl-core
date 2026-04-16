library ieee;
use IEEE.std_logic_1164.all;

entity core is
    generic (
        N : integer := 8;
        INSTR_S : integer := 4
    );
    port (
        clk : in std_logic;
        rst : in std_logic;
        en : in std_logic;
        SR_IN_L : in std_logic;
        SR_IN_R : in std_logic;
        A_IN : in std_logic_vector((N/2)-1 downto 0);
        B_IN : in std_logic_vector((N/2)-1 downto 0);

        INSTR_IN : in std_logic_vector(9 downto 0);

        RES_OUT : out std_logic_vector(N-1 downto 0);
        SR_OUT_L : out std_logic;
        SR_OUT_R : out std_logic;
        res_available : out std_logic
    );
end core;

architecture core_arch of core is
    signal SEL_ROUTE : std_logic_vector(3 downto 0);

    signal S : std_logic_vector((N-1) downto 0);

    signal buff_a_in : std_logic_vector((N/2)-1 downto 0);
    signal buff_a_out : std_logic_vector((N/2)-1 downto 0);
    signal buff_a_en : std_logic;

    signal buff_b_in : std_logic_vector((N/2)-1 downto 0);
    signal buff_b_out : std_logic_vector((N/2)-1 downto 0);
    signal buff_b_en : std_logic;

    signal buff_sr_in : std_logic_vector(1 downto 0);
    signal buff_sr_out : std_logic_vector(1 downto 0);
    signal buff_sr_en : std_logic;

    signal mem_cache_1_in : std_logic_vector(N-1 downto 0);
    signal mem_cache_1_out : std_logic_vector(N-1 downto 0);
    signal mem_cache_1_en : std_logic;

    signal mem_cache_2_in : std_logic_vector(N-1 downto 0);
    signal mem_cache_2_out : std_logic_vector(N-1 downto 0);
    signal mem_cache_2_en : std_logic;

    signal mem_sel_fct_in : std_logic_vector(3 downto 0);
    signal mem_sel_fct_out : std_logic_vector(3 downto 0);
    signal mem_sel_fct_en : std_logic;

    signal mem_sel_out_in : std_logic_vector(1 downto 0);
    signal mem_sel_out_out : std_logic_vector(1 downto 0);
    signal mem_sel_out_en : std_logic;
begin
    mem_sel_fct : entity work.bufferNbits
    generic map (
        N => 4
    )
    port map (
        clk => clk,
        en => mem_sel_fct_en,
        rst => rst,
        e1 => mem_sel_fct_in,
        s1 => mem_sel_fct_out
    );

    mem_sel_out : entity work.bufferNbits
    generic map (
        N => 2
    )
    port map (
        clk => clk,
        en => mem_sel_out_en,
        rst => rst,
        e1 => mem_sel_out_in,
        s1 => mem_sel_out_out
    );

    mem_cache_1 : entity work.bufferNbits
    generic map (
        N => N
    )
    port map (
        clk => clk,
        en => mem_cache_1_en,
        rst => rst,
        e1 => mem_cache_1_in,
        s1 => mem_cache_1_out
    );

    mem_cache_2 : entity work.bufferNbits
    generic map (
        N => N
    )
    port map (
        clk => clk,
        en => mem_cache_2_en,
        rst => rst,
        e1 => mem_cache_2_in,
        s1 => mem_cache_2_out
    );

    buffer_a : entity work.bufferNbits
    generic map (
        N => (N/2)
    )
    port map (
        clk => clk,
        en => buff_a_en,
        rst => rst,
        e1 => buff_a_in,
        s1 => buff_a_out
    );

    buffer_b : entity work.bufferNbits
    generic map (
        N => (N/2)
    )
    port map (
        clk => clk,
        en => buff_b_en,
        rst => rst,
        e1 => buff_b_in,
        s1 => buff_b_out
    );

    buffer_sr : entity work.bufferNbits
    generic map (
        N => 2
    )
    port map (
        clk => clk,
        en => buff_sr_en,
        rst => rst,
        e1 => buff_sr_in,
        s1 => buff_sr_out
    );

    ual : entity work.UAL
    generic map (
        N => N,
        INSTR_S => INSTR_S
    )
    port map (
        SEL_FCT => mem_sel_fct_out,
        SR_IN_L => buff_sr_out(1),
        SR_IN_R => buff_sr_out(0),
        SR_OUT_L => SR_OUT_L,
        SR_OUT_R => SR_OUT_R,
        S => S,
        Buffer_A => buff_a_out,
        Buffer_B => buff_b_out
    );

    SEL_ROUTE <= INSTR_IN(5 downto 2);
    mem_sel_fct_in <= INSTR_IN(9 downto 6);
    mem_sel_out_in <= INSTR_IN(1 downto 0);

    buff_sr_in(0) <= SR_IN_R;
    buff_sr_in(1) <= SR_IN_L;

    mem_sel_fct_en <= '1';
    mem_sel_out_en <= '1';
    buff_sr_en <= '1';

    selection_output : process(all)
    begin
        -- if falling_edge(clk) then
        case mem_sel_out_out is
            when "00" =>
                RES_OUT <= (others => '0');
                res_available <= '0';
            when "01" =>
                RES_OUT <= mem_cache_1_out;
                res_available <= '1';
            when "10" =>
                RES_OUT <= mem_cache_2_out;
                res_available <= '1';
            when "11" =>
                RES_OUT <= S;
                res_available <= '1';
            when others =>
                RES_OUT <= (others => '0');
                res_available <= '0';
        end case;
        -- end if;
    end process;

    selection_route : process(all)
    begin
        buff_a_in <= (others => '0');
        buff_a_en <= '0';
        buff_b_in <= (others => '0');
        buff_b_en <= '0';
        mem_cache_1_in <= (others => '0');
        mem_cache_1_en <= '0';
        mem_cache_2_in <= (others => '0');
        mem_cache_2_en <= '0';

        if en = '1' then
            case SEL_ROUTE is
                when "0000" =>
                    buff_a_in <= A_IN;
                    buff_a_en <= '1';
                when "0001" =>
                    buff_b_in <= B_IN;
                    buff_b_en <= '1';
                when "0010" =>
                    buff_a_in <= S((N/2)-1 downto 0);
                    buff_a_en <= '1';
                when "0011" =>
                    buff_a_in <= S(N-1 downto (N/2));
                    buff_a_en <= '1';
                when "0100" =>
                    buff_b_in <= S((N/2)-1 downto 0);
                    buff_b_en <= '1';
                when "0101" =>
                    buff_b_in <= S(N-1 downto (N/2));
                    buff_b_en <= '1';
                when "0110" =>
                    mem_cache_1_in <= S;
                    mem_cache_1_en <= '1';
                when "0111" =>
                    mem_cache_2_in <= S;
                    mem_cache_2_en <= '1';
                when "1000" =>
                    buff_a_in <= mem_cache_1_out((N/2)-1 downto 0);
                    buff_a_en <= '1';
                when "1001" =>
                    buff_a_in <= mem_cache_1_out(N-1 downto (N/2));
                    buff_a_en <= '1';
                when "1010" =>
                    buff_b_in <= mem_cache_1_out((N/2)-1 downto 0);
                    buff_b_en <= '1';
                when "1011" =>
                    buff_b_in <= mem_cache_1_out(N-1 downto (N/2));
                    buff_b_en <= '1';
                when "1100" =>
                    buff_a_in <= mem_cache_2_out((N/2)-1 downto 0);
                    buff_a_en <= '1';
                when "1101" =>
                    buff_a_in <= mem_cache_2_out(N-1 downto (N/2));
                    buff_a_en <= '1';
                when "1110" =>
                    buff_b_in <= mem_cache_2_out((N/2)-1 downto 0);
                    buff_b_en <= '1';
                when "1111" =>
                    buff_b_in <= mem_cache_2_out(N-1 downto (N/2));
                    buff_b_en <= '1';
                when others =>
                    null;
            end case;
        end if;
    end process;

end architecture;