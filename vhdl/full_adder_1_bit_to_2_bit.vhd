-- Full adder that takes in 2x1bit values, returns 2 bit sum

-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

library ieee;
use ieee.std_logic_1164.all;

entity FULL_ADDER_1_BIT_TO_2_BIT is
    port (
        A   : in  std_logic;
        B   : in  std_logic;
        SUM : out std_logic_vector(1 downto 0)
    );
end entity FULL_ADDER_1_BIT_TO_2_BIT;

architecture RTL of FULL_ADDER_1_BIT_TO_2_BIT is

    component FULL_ADDER is
        port (
            A     : in  std_logic;
            B     : in  std_logic;
            C_IN  : in  std_logic;
            SUM   : out std_logic;
            CARRY : out std_logic
        );
    end component FULL_ADDER;

begin

    adder : FULL_ADDER
        port map (
            A     => A,
            B     => B,
            C_IN  => '0',
            SUM   => SUM(0),
            CARRY => SUM(1)
        );

end architecture RTL;