--- Testbench for SYSTEM_MEMORY_V3

-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity SYSTEM_MEMORY_V3_TB is
    generic (
        runner_cfg : string
    );
end entity SYSTEM_MEMORY_V3_TB;

architecture TEST of SYSTEM_MEMORY_V3_TB is

    constant DATA_SIZE    : positive := 5;
    constant CLOCK_PERIOD : time     := 20 ns;

    component SYSTEM_MEMORY_V3 is
        generic (
            data_size : positive := 64
        );
        port (
            GRID_IN        : in  std_logic_vector((data_size - 1) downto 0);
            SERIAL_IN      : in  std_logic;
            LOAD_MODE      : in  std_logic;
            RUN_MODE       : in  std_logic;
            OUTPUT_MODE    : in  std_logic;
            CLK            : in  std_logic;
            RESET          : in  std_logic;
            SYSTEM_MEM_OUT : out std_logic_vector((data_size - 1) downto 0);
            SERIAL_OUT     : out std_logic
        );
    end component SYSTEM_MEMORY_V3;

    signal GRID_IN        : std_logic_vector((DATA_SIZE - 1) downto 0);
    signal SERIAL_IN      : std_logic;
    signal LOAD_MODE      : std_logic;
    signal RUN_MODE       : std_logic;
    signal OUTPUT_MODE    : std_logic;
    signal CLK            : std_logic;
    signal RESET          : std_logic;
    signal SYSTEM_MEM_OUT : std_logic_vector((DATA_SIZE - 1) downto 0);
    signal SERIAL_OUT     : std_logic;
    signal TEST_DONE      : std_logic := '0';

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

    dut : SYSTEM_MEMORY_V3
        generic map (
            data_size => DATA_SIZE
        )
        port map (
            GRID_IN        => GRID_IN,
            SERIAL_IN      => SERIAL_IN,
            LOAD_MODE      => LOAD_MODE,
            RUN_MODE       => RUN_MODE,
            OUTPUT_MODE    => OUTPUT_MODE,
            CLK            => CLK,
            RESET          => RESET,
            SYSTEM_MEM_OUT => SYSTEM_MEM_OUT,
            SERIAL_OUT     => SERIAL_OUT
        );

    test_proc : process is
    begin

        test_runner_setup(runner, runner_cfg);

        GRID_IN     <= "00000";
        SERIAL_IN   <= '0';
        LOAD_MODE   <= '0';
        RUN_MODE    <= '0';
        RESET       <= '0';
        OUTPUT_MODE <= '0';

        -- Reset system
        RESET <= '1';
        wait for 1 ns;
        RESET <= '0';
        run_clock(CLK);

        -- Test that nothing is loaded when neither MODE bit is set
        GRID_IN   <= "11001";
        SERIAL_IN <= '1';
        run_clock(CLK);
        check_equal(SYSTEM_MEM_OUT, std_logic_vector'("00000"), "No output when mode bits not set");
        check_equal(SERIAL_OUT, '0', "No output when OUTPUT mode not set 1");

        -- Set LOAD_MODE and confirm memory is now set from SERIAL_IN
        GRID_IN   <= "00110";
        LOAD_MODE <= '1';
        run_clock(CLK);
        check_equal(SYSTEM_MEM_OUT, std_logic_vector'("00001"), "Loaded one byte");
        check_equal(SERIAL_OUT, '0', "No output when OUTPUT mode not set 2");

        -- Try loading a couple more bytes to confirm shifting works as expected
        SERIAL_IN <= '0';
        run_clock(CLK);
        run_clock(CLK);
        SERIAL_IN <= '1';
        run_clock(CLK);
        check_equal(SYSTEM_MEM_OUT, std_logic_vector'("01001"), "Loaded more bytes serially");
        check_equal(SERIAL_OUT, '0', "No output when OUTPUT mode not set 3");

        -- Set RUN_MODE and confirm that
        -- A) It takes precedence over LOAD_MODE
        -- B) It loads as expected
        RUN_MODE <= '1';
        GRID_IN  <= "00110";
        run_clock(CLK);
        check_equal(SYSTEM_MEM_OUT, std_logic_vector'("00110"), "Loaded from GRID_IN");
        check_equal(SERIAL_OUT, '0', "No output when OUTPUT mode not set 4");

        -- Turn off both LOAD_MODE and RUN_MODE and confirm data is persisted after
        -- a couple of clocks
        RUN_MODE  <= '0';
        LOAD_MODE <= '0';
        SERIAL_IN <= '0';
        GRID_IN   <= "00000";
        run_clock(CLK);
        run_clock(CLK);
        check_equal(SYSTEM_MEM_OUT, std_logic_vector'("00110"), "Data persisted after load.");
        check_equal(SERIAL_OUT, '0', "No output when OUTPUT mode not set 5");

        -- Reset and confirm value is reset
        RESET <= '1';
        wait for 1 ns;
        RESET <= '0';
        check_equal(SYSTEM_MEM_OUT, std_logic_vector'("00000"), "Data reset");
        check_equal(SERIAL_OUT, '0', "No output when OUTPUT mode not set 6");

        -- Load data in to test output shift register
        RUN_MODE <= '1';
        GRID_IN  <= "01101";
        run_clock(CLK);
        check_equal(SYSTEM_MEM_OUT, std_logic_vector'("01101"), "Loaded data for testing output shift reg");

        -- Test reading out the loaded bytes.
        RUN_MODE    <= '0';
        OUTPUT_MODE <= '1';
        run_clock(CLK);
        check_equal(SYSTEM_MEM_OUT, std_logic_vector'("01101"), "System memory persists during output 1");
        check_equal(SERIAL_OUT, '0', "First byte shifted out");

        run_clock(CLK);
        check_equal(SYSTEM_MEM_OUT, std_logic_vector'("01101"), "System memory persists during output 2");
        check_equal(SERIAL_OUT, '1', "Second byte shifted out");

        run_clock(CLK);
        check_equal(SYSTEM_MEM_OUT, std_logic_vector'("01101"), "System memory persists during output 3");
        check_equal(SERIAL_OUT, '1', "Third byte shifted out");

        run_clock(CLK);
        check_equal(SYSTEM_MEM_OUT, std_logic_vector'("01101"), "System memory persists during output 4");
        check_equal(SERIAL_OUT, '0', "Fourth byte shifted out");

        run_clock(CLK);
        check_equal(SYSTEM_MEM_OUT, std_logic_vector'("01101"), "System memory persists during output 5");
        check_equal(SERIAL_OUT, '1', "Fifth byte shifted out");

        RESET <= '1';
        wait for 1 ns;
        RESET <= '0';

        LOAD_MODE   <= '0';
        RUN_MODE    <= '0';
        OUTPUT_MODE <= '0';

        -- Test that LOAD_MODE has precedence over OUTPUT_MODE
        OUTPUT_MODE <= '1';
        LOAD_MODE   <= '1';
        SERIAL_IN   <= '1';
        GRID_IN     <= "11011";
        run_clock(CLK);
        check_equal(SYSTEM_MEM_OUT, std_logic_vector'("00001"), "LOAD has precedence over OUTPUT");

        -- Test that RUN_MODE has precedence over LOAD_MODE
        RUN_MODE    <= '1';
        OUTPUT_MODE <= '0';
        LOAD_MODE   <= '1';
        run_clock(CLK);
        check_equal(SYSTEM_MEM_OUT, std_logic_vector'("11011"), "RUN has precedence over LOAD");

        -- Test that RUN_MODE has precedence over OUTPUT_MODE
        RUN_MODE    <= '1';
        OUTPUT_MODE <= '1';
        LOAD_MODE   <= '0';
        GRID_IN     <= "00110";
        run_clock(CLK);
        check_equal(SYSTEM_MEM_OUT, std_logic_vector'("00110"), "RUN has precedence over OUTPUT");

        test_runner_cleanup(runner);

    end process test_proc;

end architecture TEST;