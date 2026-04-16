-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

-- Déclaration d'une entité pour la simulation sans ports d'entrées et de sorties
entity tb_bufferNbits is

end tb_bufferNbits;

architecture impl of tb_bufferNbits is

    -- Déclaration de la constante pour le paramètre générique (non obligatoire)
    constant N : integer := 4;

    -- Déclaration de la constante permettant de définir la période de l'horloge
    constant PERIOD : time := 50 us;

    -- Déclaration des signaux internes à l'architecture pour réaliser les simulations
    signal e1_sim : std_logic_vector(N-1 downto 0) := (others => '0');
    signal s1_sim : std_logic_vector(N-1 downto 0) := (others => '0');
    signal reset_sim  : std_logic := '0';
    signal enable_sim : std_logic := '0';
    signal clock_sim  : std_logic := '0';
begin
    -- Instanciation du composant à tester
    b : entity work.bufferNbits
    -- raccordement des ports du composant aux signaux dans l'architecture
    generic map (
        N => N
    )
    port map (
        e1     => e1_sim,
        rst  => reset_sim,
        en => enable_sim,
        clk  => clock_sim,
        s1     => s1_sim
    );

    -- Définition du process permettant de générer l'horloge pour le test
    proc1 : process -- pas de liste de sensibilité
    begin
        clock_sim <= '0';
        wait for (4*PERIOD)/5;
        clock_sim <= '1';
        wait for PERIOD/5;

        if now = (8*(2**N))*PERIOD then
            wait;
        end if;

    end process;

    -- Définition du process permettant de faire évoluer les signaux d'entrée du composant à tester
    proc2 : process -- pas de liste de sensibilité
    begin

        for i in 0 to 1 loop
            for j in 0 to 1 loop
                for k in 0 to (2**N)-1 loop
                    e1_sim <= std_logic_vector(to_unsigned(k, N));
                    enable_sim <= to_unsigned(j,1)(0);
                    reset_sim  <= to_unsigned(i,1)(0);

                    wait for 2*PERIOD;

                    report "reset = " & integer'image(i) &
                           " | enable = " & integer'image(j) &
                           " | e1 = " & integer'image(k) &
                           " || s1 = " & integer'image(to_integer(unsigned(s1_sim)));
                end loop;
            end loop;
        end loop;

        report "Test done";
        wait;

    end process;

end architecture;