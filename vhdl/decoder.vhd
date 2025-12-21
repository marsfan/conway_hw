--- Simple 4 output decoder

-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https: //mozilla.org/MPL/2.0/.

library ieee;
use ieee.std_logic_1164.all;

entity DECODER is
    port (
        VAL_IN : in  std_logic_vector(1 downto 0);
        VAL_00 : out std_logic; -- High when input is 00
        VAL_01 : out std_logic; -- High when input is 01
        VAL_10 : out std_logic; -- High when input is 10
        VAL_11 : out std_logic  -- High when input is 11
    );
end entity DECODER;

architecture RTL of DECODER is

begin

    -- FIXME: is there a better way to write this?
    VAL_00 <= '1' when VAL_IN = "00" else '0';
    VAL_01 <= '1' when VAL_IN = "01" else '0';
    VAL_10 <= '1' when VAL_IN = "10" else '0';
    VAL_11 <= '1' when VAL_IN = "11" else '0';

end architecture RTL;