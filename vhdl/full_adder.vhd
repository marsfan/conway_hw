-- A single bit full adder

-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

library ieee;
use ieee.std_logic_1164.all;

entity FULL_ADDER is
    port (
        A     : in  std_logic;
        B     : in  std_logic;
        C_IN  : in  std_logic;
        SUM   : out std_logic;
        CARRY : out std_logic
    );
end entity FULL_ADDER;

architecture RTL of FULL_ADDER is

begin

    SUM <= A XOR B XOR C_IN;

    CARRY <= (A AND B) OR (A AND C_IN) OR (B AND C_IN);

end architecture RTL;
