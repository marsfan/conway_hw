--- Testbench for SYSTEM_MEMORY

-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity SYSTEM_MEMORY_TB is
    generic (
        runner_cfg : string
    );
end entity SYSTEM_MEMORY_TB;

architecture TEST of SYSTEM_MEMORY_TB is

    constant DATA_SIZE    : positive := 5;
    constant CLOCK_PERIOD : time     := 20 ns;

    component SYSTEM_MEMORY is
        generic (
            data_size : positive
        );
        port (
            INITIAL_IN   : in  std_logic_vector((data_size - 1) downto 0);
            GRID_IN      : in  std_logic_vector((data_size - 1) downto 0);
            WRITE_ENABLE : in  std_logic;
            LOAD_RUN     : in  std_logic;
            CLK          : in  std_logic;
            RESET        : in  std_logic;
            MEM_OUT      : out std_logic_vector((data_size - 1) downto 0)
        );
    end component SYSTEM_MEMORY;

    signal INITIAL_IN   : std_logic_vector((DATA_SIZE - 1) downto 0);
    signal GRID_IN      : std_logic_vector((DATA_SIZE - 1) downto 0);
    signal WRITE_ENABLE : std_logic;
    signal LOAD_RUN     : std_logic;
    signal CLK          : std_logic;
    signal RESET        : std_logic;
    signal MEM_OUT      : std_logic_vector((DATA_SIZE - 1) downto 0);
    signal TEST_DONE    : std_logic := '0';

    procedure run_clock (
        signal LCLK : out std_logic
    ) is
    begin

        LCLK <= '0';
        wait for CLOCK_PERIOD / 2;
        LCLK <= '1';
        wait for CLOCK_PERIOD / 2;

        if TEST_DONE = '1' then
            -- End the process if TEST_DONE signal is set.
            assert false report "end of test" severity note;
            wait;
        end if;

    end procedure run_clock;

begin

    dut : SYSTEM_MEMORY
        generic map (
            data_size => DATA_SIZE
        )
        port map (
            INITIAL_IN   => INITIAL_IN,
            GRID_IN      => GRID_IN,
            WRITE_ENABLE => WRITE_ENABLE,
            LOAD_RUN     => LOAD_RUN,
            CLK          => CLK,
            RESET        => RESET,
            MEM_OUT      => MEM_OUT
        );

    test_proc : process is
    begin

        test_runner_setup(runner, runner_cfg);

        INITIAL_IN   <= "00000";
        GRID_IN      <= "00000";
        WRITE_ENABLE <= '0';
        LOAD_RUN     <= '0';
        CLK          <= '0';
        RESET        <= '0';

        -- Reset system
        RESET <= '1';
        wait for 1 ns;
        RESET <= '0';

        run_clock(CLK);

        -- Test that nothing is loaded when WRITE_ENABLE = '0';
        INITIAL_IN <= "11001";
        GRID_IN    <= "00110";
        run_clock(CLK);
        check_equal(MEM_OUT, std_logic_vector'("00000"), "No output when WE = '0'");

        -- Set WE and confirm memory is now set from INITIAL_IN
        WRITE_ENABLE <= '1';
        run_clock(CLK);
        check_equal(MEM_OUT, std_logic_vector'("11001"), "Memory Updated from INITIAL_IN");

        -- Clear WE and confirm value stays the same
        WRITE_ENABLE <= '0';
        INITIAL_IN   <= "00000";
        run_clock(CLK);
        check_equal(MEM_OUT, std_logic_vector'("11001"), "Value stayed at old INITIAL_IN");

        -- Set WE, switch to run mode, and confirm we arre getting grid value
        WRITE_ENABLE <= '1';
        LOAD_RUN     <= '1';
        run_clock(CLK);
        check_equal(MEM_OUT, std_logic_vector'("00110"), "Memory Updated from GRID_IN");

        -- Clear WE and confirm value stays the same
        WRITE_ENABLE <= '0';
        GRID_IN      <= "00000";
        run_clock(CLK);
        check_equal(MEM_OUT, std_logic_vector'("00110"), "Value stayed at old GRID_IN");

        -- Reset and confirm value is reset
        RESET <= '1';
        wait for 1 ns;
        RESET <= '0';
        check_equal(MEM_OUT, std_logic_vector'("00000"), "Value was reset");

        test_runner_cleanup(runner);

    end process test_proc;

end architecture TEST;