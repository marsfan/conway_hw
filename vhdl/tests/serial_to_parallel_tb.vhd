--- Test bench for the SERIAL_TO_PARALLEL entity

-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https: //mozilla.org/MPL/2.0/.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity SERIAL_TO_PARALLEL_TB is
    generic (
        runner_cfg : string
    );
end entity SERIAL_TO_PARALLEL_TB;

architecture TEST of SERIAL_TO_PARALLEL_TB is

    constant DEPTH        : positive := 3;
    constant CLOCK_PERIOD : time     := 20 ns;

    component SERIAL_TO_PARALLEL is
        generic (
            data_size : positive := 64
        );
        port (
            DATA_IN : in  std_logic;
            EN      : in  std_logic;
            CLK     : in  std_logic;
            RST     : in  std_logic;
            DATA    : out std_logic_vector((data_size - 1) downto 0)
        );
    end component SERIAL_TO_PARALLEL;

    signal DATA_IN   : std_logic;
    signal EN        : std_logic;
    signal CLK       : std_logic;
    signal RST       : std_logic;
    signal DATA      : std_logic_vector((DEPTH - 1) downto 0);
    signal TEST_DONE : std_logic := '0';

    procedure run_clock(signal lclk: out std_logic) is
    begin
        lclk <= '0';
        wait for CLOCK_PERIOD / 2;
        lclk <= '1';
        wait for CLOCK_PERIOD / 2;
        if TEST_DONE = '1' then
            -- End the process if TEST_DONE signal is set.
            assert false report "end of test" severity note;
            wait;
        end if;
    end procedure run_clock;

begin

    dut : SERIAL_TO_PARALLEL
        generic map (
            data_size => DEPTH
        )
        port map (
            DATA_IN => DATA_IN,
            EN      => EN,
            CLK     => CLK,
            RST     => RST,
            DATA    => DATA
        );

    -- -- Process for running the clock signal
    -- clock_process : process is
    -- begin

    --     CLK <= '0';
    --     wait for CLOCK_PERIOD / 2;
    --     CLK <= '1';
    --     wait for CLOCK_PERIOD / 2;

    --     if TEST_DONE = '1' then
    --         -- End the process if TEST_DONE signal is set.
    --         assert false report "end of test" severity note;
    --         wait;
    --     end if;

    -- end process clock_process;

    test_proc : process is
    begin

        test_runner_setup(runner, runner_cfg);
        EN <= '0';
        DATA_IN <= '0';

        -- Reset system
        RST <= '1';
        wait for 1 ns;
        check_equal(DATA, std_logic_vector'("000"), "Reset failed");

        -- Clear reset flag
        RST <= '0';

        -- Check we don't load when EN is 0
        DATA_IN <= '1';
        run_clock(CLK);
        check_equal(DATA, std_logic_vector'("000"), "No loaded when EN = '0'");

        -- Set enable and shift in
        EN <= '1';
        DATA_IN <= '1';
        run_clock(CLK);
        check_equal(DATA, std_logic_vector'("001"), "Loaded a byte");

        DATA_IN <= '0';
        -- Check it gets shifted up a byte
        run_clock(CLK);
        check_equal(DATA, std_logic_vector'("010"), "Byte was shifted");

        -- Load another byte
        DATA_IN <= '1';
        run_clock(CLK);
        check_equal(DATA, std_logic_vector'("101"), "Second byte loaded");


        -- Ensure after clearing EN we get no new bytes for a few cycles
        DATA_IN <= '0';
        EN <= '0';
        run_clock(CLK);
        run_clock(CLK);
        run_clock(CLK);
        check_equal(DATA, std_logic_vector'("101"), "No change after clearing EN");

        -- Reset everything
        RST <= '1';
        wait for 1 ns;
        check_equal(DATA, std_logic_vector'("000"), "Reset at end failed");

        test_runner_cleanup(runner);

    end process test_proc;

end architecture TEST;



