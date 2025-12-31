--- Testbench for SYSTEM_MEMORY_V4

-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https: //mozilla.org/MPL/2.0/.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity CELL_GRID_TB is
    generic (
        runner_cfg : string
    );
end entity CELL_GRID_TB;

architecture TEST of CELL_GRID_TB is

    component CELL_GRID is
        generic (
            grid_width  : positive;
            grid_height : positive
        );
        port (
            INPUT_STATE : in  std_logic_vector((grid_width * grid_height - 1) downto 0);
            NEXT_STATE  : out std_logic_vector((grid_width * grid_height - 1) downto 0)
        );
    end component CELL_GRID;

    signal INPUT_STATE : std_logic_vector(63 downto 0);
    signal NEXT_STATE  : std_logic_vector(63 downto 0);

begin

    dut : CELL_GRID
        generic map (
            grid_width  => 8,
            grid_height => 8
        )
        port map (
            INPUT_STATE => INPUT_STATE,
            NEXT_STATE  => NEXT_STATE
        );

    test_proc : process is
    begin

        test_runner_setup(runner, runner_cfg);

        -- Testing a few of the different patterns from the
        -- Wikipeida page on conway's game of life.

        INPUT_STATE <= x"0000001818000000";
        wait for 1 ns;
        check_equal(NEXT_STATE, std_logic_vector'(x"0000001818000000"), "Block");

        INPUT_STATE <= x"0000102828100000";
        wait for 1 ns;
        check_equal(NEXT_STATE, std_logic_vector'(x"0000102828100000"), "Behive");

        INPUT_STATE <= x"0000001010100000";
        wait for 1 ns;
        check_equal(NEXT_STATE, std_logic_vector'(x"0000000038000000"), "Blinker");

        INPUT_STATE <= x"0060601818000000";
        wait for 1 ns;
        check_equal(NEXT_STATE, std_logic_vector'(x"0060400818000000"), "Beacon");

        INPUT_STATE <= x"C080000000000000";
        wait for 1 ns;
        check_equal(NEXT_STATE, std_logic_vector'(x"C0C0000000000000"), "Corner1");

        INPUT_STATE <= x"8080800000000000";
        wait for 1 ns;
        check_equal(NEXT_STATE, std_logic_vector'(x"00C0000000000000"), "Corner2");

        test_runner_cleanup(runner);

    end process test_proc;

end architecture TEST;