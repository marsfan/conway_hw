--- Memory for the system.
--- V3 has both the input and output shift registers here. This allows us to load
--- the output shift register from serial in as well, so that after load the
--- output register holds the current state, instead of having a "lag"

-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https: //mozilla.org/MPL/2.0/.

library ieee;
use ieee.std_logic_1164.all;

entity SYSTEM_MEMORY_V3 is
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
end entity SYSTEM_MEMORY_V3;

architecture RTL of SYSTEM_MEMORY_V3 is

    -- Input shift register memory
    signal INPUT_SR : std_logic_vector((data_size - 1) downto 0) := (others => '0');

    -- Output shift register memory
    signal OUTPUT_SR : std_logic_vector((data_size - 1) downto 0) := (others => '0');

begin

    -- Got this from here: https://vhdlwhiz.com/shift-register/
    -- TODO: Re-write as a single process (testing shows the same resource use when I do that)
    input_shift_register_process : process(CLK, RESET) is
    begin

        if RESET = '1' then
            INPUT_SR <= (others => '0');
        elsif rising_edge(CLK) then
            if RUN_MODE = '1' then
                INPUT_SR <= GRID_IN;
            elsif LOAD_MODE = '1' then
                -- Take a slice of the bottom 63 elements, and concatenate it with the new value
                -- This means we have shifted everying up one bit, and shifted in the new value at the bottom
                -- & is concatenate in VHDL
                INPUT_SR <= INPUT_SR((INPUT_SR'high - 1) downto INPUT_SR'low) & SERIAL_IN;
            end if;
        end if;

    end process input_shift_register_process;

    output_shift_register_process : process(CLK, RESET) is
    begin

        if RESET = '1' then
            SERIAL_OUT <= '0';
            OUTPUT_SR  <= (others => '0');
        elsif rising_edge(CLK) then
            if RUN_MODE = '1' then
                OUTPUT_SR <= GRID_IN;
            elsif LOAD_MODE = '1' then
                -- Take a slice of the bottom 63 elements, and concatenate it with the new value
                -- This means we have shifted everying up one bit, and shifted in the new value at the bottom
                -- & is concatenate in VHDL
                OUTPUT_SR <= OUTPUT_SR((OUTPUT_SR'high - 1) downto OUTPUT_SR'low) & SERIAL_IN;
            elsif OUTPUT_MODE = '1' then
                -- Push out the highest value
                SERIAL_OUT <= OUTPUT_SR(OUTPUT_SR'high);

                -- Concatenate a zero with the lower 63 elements.
                -- This means we have shifted everything down one bit, and shifted
                -- in a zero at the top.
                -- & is concatenate in VHDL
                OUTPUT_SR <= OUTPUT_SR(OUTPUT_SR'high - 1 downto (OUTPUT_SR'low)) & '0';
            end if;
        end if;

    end process output_shift_register_process;

    -- Write input shift register values to parallel output.
    SYSTEM_MEM_OUT <= INPUT_SR;

end architecture RTL;