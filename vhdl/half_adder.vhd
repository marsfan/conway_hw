-- A half adder

-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https: //mozilla.org/MPL/2.0/.
library ieee;
use ieee.std_logic_1164.all;

entity HALF_ADDER is
    port (
        A     : in std_logic;
        B     : in std_logic;
        SUM   : out std_logic;
        CARRY : out std_logic
    );
end entity HALF_ADDER;

architecture RTL of HALF_ADDER is
begin
        SUM <= A XOR B;
        CARRY <= A AND B;
end RTL;