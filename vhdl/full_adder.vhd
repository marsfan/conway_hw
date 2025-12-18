-- A single bit full adder

-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https: //mozilla.org/MPL/2.0/.
library ieee;
use ieee.std_logic_1164.all;

entity FULL_ADDER is
    port (
        A     : in std_logic;
        B     : in std_logic;
        C_IN  : in std_logic;
        SUM   : out std_logic;
        CARRY : out std_logic
    );
end FULL_ADDER;

architecture RTL of FULL_ADDER is

    -- Intermediate carry out signals
    signal SUM_INTERMEDIATE : std_logic;
    signal C_OUT_1          : std_logic;
    signal C_OUT_2          : std_logic;

    component HALF_ADDER is
        port (
            A     : in std_logic;
            B     : in std_logic;
            SUM   : out std_logic;
            CARRY : out std_logic
        );
    end component HALF_ADDER;

begin

    -- First of the half-adders
    first_half : HALF_ADDER port map (
        A => A,
        B => B,
        SUM => SUM_INTERMEDIATE,
        CARRY => C_OUT_1
    );

    -- Second of the half-adders
    second_half : HALF_ADDER port map (
        A => SUM_INTERMEDIATE,
        B => C_IN,
        SUM => SUM,
        CARRY => C_OUT_2
    );

    -- Final carry is if either half adder carry is true
    CARRY <= C_OUT_1 OR C_OUT_2;

end architecture RTL;

