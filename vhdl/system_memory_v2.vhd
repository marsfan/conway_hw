--- Memory for the system.
--- V2 combines the memory with the serial input system, reducing the amount o
--- logic used.

-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

library ieee;
use ieee.std_logic_1164.all;

entity SYSTEM_MEMORY_V2 is
    generic (
        data_size : positive := 64
    );
    port (
        GRID_IN   : in  std_logic_vector((data_size - 1) downto 0); -- Input from the grid calculator
        SERIAL_IN : in  std_logic; -- Serial input from external interface

        -- If both are asserted, then RUN_MODE will take priority
        LOAD_MODE : in  std_logic; -- Indicates system is in load mode (i.e. load from serial)
        RUN_MODE  : in  std_logic; -- Indcates system is in run mode (i.e. load from grid in)
        CLK       : in  std_logic; -- System clock
        RESET     : in  std_logic; -- Asynchronous reset.
        DATA_OUT  : out std_logic_vector((data_size - 1) downto 0) -- Memory output
    );
end entity SYSTEM_MEMORY_V2;

architecture RTL of SYSTEM_MEMORY_V2 is

    signal SR_TMP : std_logic_vector((data_size - 1) downto 0) := (others => '0'); -- Intermediate shift register value.

begin

    -- Got this from here: https://vhdlwhiz.com/shift-register/
    shift_register_process : process(CLK, RESET) is
    begin

        if RESET = '1' then
            SR_TMP <= (others => '0');
        elsif rising_edge(CLK) then
            if RUN_MODE = '1' then
                SR_TMP <= GRID_IN;
            elsif LOAD_MODE = '1' then
                -- Take a slice of the bottom 63 elements, and concatenate it with the new value
                -- This means we have shifted everying up one bit, and shifted in the new value at the bottom
                -- & is concatenate in VHDL
                SR_TMP <= SR_TMP((SR_TMP'high - 1) downto SR_TMP'low) & SERIAL_IN;
            end if;
        end if;

    end process shift_register_process;

    DATA_OUT <= SR_TMP;

end architecture RTL;