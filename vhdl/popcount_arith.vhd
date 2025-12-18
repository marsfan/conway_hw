--- Count how many of the bits are set
--- This version using the ieee.numeric_std.all library to simplify the code.

-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https: //mozilla.org/MPL/2.0/.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity POPCOUNT_ARITH is
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
end entity POPCOUNT_ARITH;

architecture RTL of POPCOUNT_ARITH is

    -- Signals that have been extended from a boolean to a 4 bit value.
    -- (Since max number of bits can be 8, we need 4 bits)
    -- TODO: Do we want to implement our own adder instead of using the "unsigned" type?
    signal N_EXT  : unsigned(3 downto 0);
    signal NE_EXT : unsigned(3 downto 0);
    signal E_EXT  : unsigned(3 downto 0);
    signal SE_EXT : unsigned(3 downto 0);
    signal S_EXT  : unsigned(3 downto 0);
    signal SW_EXT : unsigned(3 downto 0);
    signal W_EXT  : unsigned(3 downto 0);
    signal NW_EXT : unsigned(3 downto 0);

begin

    -- Extend the inputs
    -- & is concatenate in VHDL (not logical AND)
    N_EXT <= "000" & N;
    NE_EXT<= "000" & NE;
    E_EXT <= "000" & E;
    SE_EXT <= "000" & SE;
    S_EXT <= "000" & S;
    SW_EXT <= "000" & SW;
    W_EXT <= "000" & W;
    NW_EXT <= "000" & NW;

    -- Sum all the inputs
    COUNT <= std_logic_vector(N_EXT + NE_EXT + E_EXT + SE_EXT + S_EXT + SW_EXT + W_EXT + NW_EXT);

end RTL;
