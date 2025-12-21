--- Shift register that shifts data in serially and outputs parallel

-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https: //mozilla.org/MPL/2.0/.

library ieee;
use ieee.std_logic_1164.all;

entity SERIAL_TO_PARALLEL is
    generic (
        data_size : positive := 64
    );
    port (
        DATA_IN : in  std_logic; -- Serial input
        EN      : in  std_logic; -- Enables shifting data in
        CLK     : in  std_logic; -- Clock in
        RST     : in  std_logic; -- Asynchronous Reset
        DATA    : out std_logic_vector((data_size - 1) downto 0) -- Parallel data out.
    );
end entity SERIAL_TO_PARALLEL;

architecture RTL of SERIAL_TO_PARALLEL is

    signal SR_TMP : std_logic_vector((data_size - 1) downto 0) := (others => '0'); -- Intermediate shift register value

begin

    -- Got this from here: https://vhdlwhiz.com/shift-register/
    shift_register_process : process(CLK, RST) is
    begin

        if RST = '1' then
            SR_TMP <= (others => '0');
        elsif rising_edge(CLK) AND (EN = '1') then
                -- Take a slice of the bottom 63 elements, and concatenate it with the new value
                -- This means we have shifted everying up one bit, and shifted in the new value at the bottom
                -- & is concatenate in VHDL
                SR_TMP <= SR_TMP((SR_TMP'high - 1) downto SR_TMP'low) & DATA_IN;

        end if;

    end process shift_register_process;

    DATA <= SR_TMP;

end architecture RTL;