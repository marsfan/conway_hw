--- Memory for the system.
--- V4 uses a single shift register for both input and outputs. To ensure
--- that data is kept event when reading out, during readout, the data is
--- shifted in a circular buffer, instead of being filled with zeros.
--- This means that reading data out MUST always be done in multiples of the
--- full data size, or the data in memory will be jumbled around between reads

-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https: //mozilla.org/MPL/2.0/.

library ieee;
use ieee.std_logic_1164.all;

entity SYSTEM_MEMORY_V4 is
    generic (
        data_size : positive := 64
    );
    port (
        -- RUN_MODE has priority.
        -- Then LOAD_MODE
        -- Then OUTPUT_MODE
        GRID_IN        : in  std_logic_vector((data_size - 1) downto 0); -- Input from the grid calculator
        SERIAL_IN      : in  std_logic; -- Serial input from external interface
        LOAD_MODE      : in  std_logic; -- Indicates system is in load mode (i.e. load from serial)
        RUN_MODE       : in  std_logic; -- Indcates system is in run mode (i.e. load from grid in)
        OUTPUT_MODE    : in  std_logic; -- Indicates system is in output mode (i.e. shift out over serial)
        CLK            : in  std_logic; -- System clock
        RESET          : in  std_logic; -- Asynchronous reset.
        SYSTEM_MEM_OUT : out std_logic_vector((data_size - 1) downto 0); -- Memory output for the system to use
        SERIAL_OUT     : out std_logic -- Serial system output
    );
end entity SYSTEM_MEMORY_V4;

architecture RTL of SYSTEM_MEMORY_V4 is

    -- Input shift register memory
    signal SR_MEM : std_logic_vector((data_size - 1) downto 0) := (others => '0');

begin

    -- Got this from here: https://vhdlwhiz.com/shift-register/
    -- TODO: Re-write as a single process (testing shows the same resource use when I do that)
    shift_register_process : process(CLK, RESET) is
    begin

        if RESET = '1' then
            SR_MEM     <= (others => '0');
            SERIAL_OUT <= '0';
        elsif rising_edge(CLK) then
            if RUN_MODE = '1' then
                SR_MEM <= GRID_IN;
            elsif LOAD_MODE = '1' then
                -- Take a slice of the bottom 63 elements, and concatenate it with the new value
                -- This means we have shifted everying up one bit, and shifted in the new value at the bottom
                -- & is concatenate in VHDL
                SR_MEM <= SR_MEM((SR_MEM'high - 1) downto SR_MEM'low) & SERIAL_IN;
            elsif OUTPUT_MODE = '1' then
                -- Push out the highest value
                SERIAL_OUT <= SR_MEM(SR_MEM'high);

                -- Rotate the data around in a circular buffer
                SR_MEM <= SR_MEM(SR_MEM'high - 1 downto SR_MEM'low) & SR_MEM(SR_MEM'high);
            end if;
        end if;

    end process shift_register_process;

    -- Write input shift register values to parallel output.
    SYSTEM_MEM_OUT <= SR_MEM;

end architecture RTL;