--- Count how many of the bits are set

-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https: //mozilla.org/MPL/2.0/.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity POPCOUNT is
    port (
        N     : in std_logic;
        NE    : in std_logic;
        E     : in std_logic;
        SE    : in std_logic;
        S     : in std_logic;
        SW    : in std_logic;
        W     : in std_logic;
        NW    : in std_logic;
        COUNT : out std_logic_vector(3 downto 0)
    );
end entity POPCOUNT;

architecture RTL of POPCOUNT is


    component FULL_ADDER_1_BIT_TO_2_BIT is
        port(
                A : in std_logic;
                B : in std_logic;

                SUM : out std_logic_vector(1 downto 0)
        );
    end component FULL_ADDER_1_BIT_TO_2_BIT;

    component FULL_ADDER_2_BIT_TO_3_BIT is
        port (
                A   : in std_logic_vector(1 downto 0);
                B   : in std_logic_vector(1 downto 0);

                SUM : out std_logic_vector(2 downto 0)
        );
    end component FULL_ADDER_2_BIT_TO_3_BIT;

    component FULL_ADDER_3_BIT_TO_4_BIT is
        port (
                A   : in std_logic_vector(2 downto 0);
                B   : in std_logic_vector(2 downto 0);

                SUM : out std_logic_vector(3 downto 0)
        );
    end component FULL_ADDER_3_BIT_TO_4_BIT;

    -- Intermediate signals for the 2 bit values
    signal SUM_1_TO_2_1 : std_logic_vector(1 downto 0);
    signal SUM_1_TO_2_2 : std_logic_vector(1 downto 0);
    signal SUM_1_TO_2_3 : std_logic_vector(1 downto 0);
    signal SUM_1_TO_2_4 : std_logic_vector(1 downto 0);

    -- Intermediate signals for the 3 bit values
    signal SUM_2_TO_3_1 : std_logic_vector(2 downto 0);
    signal SUM_2_TO_3_2 : std_logic_vector(2 downto 0);

begin

    -- First stage adders
    adder_1_to_2_1 : FULL_ADDER_1_BIT_TO_2_BIT port map (
        A => N,
        B => NE,
        SUM => SUM_1_TO_2_1
    );
    adder_1_to_2_2 : FULL_ADDER_1_BIT_TO_2_BIT port map (
        A => E,
        B => SE,
        SUM => SUM_1_TO_2_2
    );
    adder_1_to_2_3 : FULL_ADDER_1_BIT_TO_2_BIT port map (
        A => S,
        B => SW,
        SUM => SUM_1_TO_2_3
    );
    adder_1_to_2_4 : FULL_ADDER_1_BIT_TO_2_BIT port map (
        A => W,
        B => NW,
        SUM => SUM_1_TO_2_4
    );

    -- Second stage adders
    adder_2_to_3_1 : FULL_ADDER_2_BIT_TO_3_BIT port map (
        A => SUM_1_TO_2_1,
        B => SUM_1_TO_2_2,
        SUM => SUM_2_TO_3_1
    );
    adder_2_to_3_2 : FULL_ADDER_2_BIT_TO_3_BIT port map (
        A => SUM_1_TO_2_3,
        B => SUM_1_TO_2_4,
        SUM => SUM_2_TO_3_2
    );

    -- Third stage adder
    adder_3_to_4 : FULL_ADDER_3_BIT_TO_4_BIT port map (
        A => SUM_2_TO_3_1,
        B => SUM_2_TO_3_2,
        SUM => COUNT
    );

end architecture;