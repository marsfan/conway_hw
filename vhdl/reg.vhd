-- Simple register with reset capability
-- Inputs:
-- * D: Register value input
-- * WE: Register Write Enable
-- * CLK: Clock Input
-- * RESET: Reset Control
-- Outputs:
-- Q: Register Output
-- On rising edge, the value of Q will be set to the value of D if WE is true.
-- Any time RESET is set to true, the value of Q will be set to 0

-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

library ieee;
use ieee.std_logic_1164.all;

entity REG is
    generic (
        width : positive := 1
    );
    port (
        D     : in  std_logic_vector((width - 1) downto 0);
        WE    : in  std_logic;
        CLK   : in  std_logic;
        RESET : in  std_logic;
        Q     : out std_logic_vector((width - 1) downto 0)
    );
end entity REG;

architecture RTL of REG is

begin

    register_process : process(CLK, RESET) is
    begin

        if RESET = '1' then
            Q <= (others => '0');
        elsif rising_edge(CLK) AND (WE = '1') then
            Q <= D;
        end if;

    end process register_process;

end architecture RTL;