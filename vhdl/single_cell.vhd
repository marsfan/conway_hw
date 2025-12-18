--- Logic for computing next value of a single cell in the system.
--- There are 4 rules for computing the next state of the cell
---  1. If currently alive and less than 2 neighbors alive, dies (underpopulation)
---  2. If currently alive and 2 or 3 neighbors, lives
---  3. If currently alive and more than 3 neighbors, dies (overpopulation)
---  4. If currently dead and exactly three neighbors alive, lives (reproduction)
---
--- Since are computing when alive, we can just check rules 2 and 4. And assume all
--- other conditions are dead

-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https: //mozilla.org/MPL/2.0/.
library ieee;
use ieee.std_logic_1164.all;

entity SINGLE_CELL is
    port (
        -- Current value of the cell
        ME    : in std_logic;

        -- Current states of neighboring cells
        N     : in std_logic;
        NE    : in std_logic;
        E     : in std_logic;
        SE    : in std_logic;
        S     : in std_logic;
        SW    : in std_logic;
        W     : in std_logic;
        NW    : in std_logic;

        -- New value of the cell
        IS_ALIVE : out std_logic
    );
end SINGLE_CELL;

architecture RTL of SINGLE_CELL is

    signal ALIVE_NEIGHBORS : std_logic_vector(3 downto 0); -- Number of neighbors that are alive.
    signal ALIVE_NEIGHBORS_2 : std_logic; -- Number of alive neighbors is 2
    signal ALIVE_NEIGHBORS_3 : std_logic; -- Number of alive neighbors is 3
    signal RULE_2_ALIVE : std_logic; -- Whether or not we live as per rule 2
    signal RULE_4_ALIVE : std_logic; -- Whether or not we live as per rule 4

    -- Declare that we are going to use the POPCOUNT entity
    component POPCOUNT is
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
    end component POPCOUNT;


begin

    -- Count the number of living neighbors
    counter : popcount port map(
        N => N,
        NE => NE,
        E => E,
        SE => SE,
        S => S,
        SW => SW,
        W => W,
        NW => NW,
        COUNT => ALIVE_NEIGHBORS
    );

    -- Checking if number of neighbors is 2 or 3
    ALIVE_NEIGHBORS_2 <= '1' when ALIVE_NEIGHBORS = "0010" else '0';
    ALIVE_NEIGHBORS_3 <= '1' when ALIVE_NEIGHBORS = "0011" else '0';

    -- Evaluating rules 2 and 4
    RULE_2_ALIVE <= (ALIVE_NEIGHBORS_2 OR ALIVE_NEIGHBORS_3) AND ME;
    RULE_4_ALIVE <= ALIVE_NEIGHBORS_3 AND NOT ME;

    -- If either rule is alive, then we are alive
    IS_ALIVE <= RULE_2_ALIVE OR RULE_4_ALIVE;

end architecture RTL;
