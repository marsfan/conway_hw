--- Test bench for PARALLEL_TO_SERIAL

-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity PARALLEL_TO_SERIAL_TB is
    generic (
        runner_cfg : string
    );
end entity PARALLEL_TO_SERIAL_TB;

architecture TEST of PARALLEL_TO_SERIAL_TB is

    constant DEPTH        : positive := 3;
    constant CLOCK_PERIOD : time     := 20 ns;

    component PARALLEL_TO_SERIAL is
        generic (
            data_size : positive
        );
        port (
            DATA_IN  : in  std_logic_vector((data_size - 1) downto 0);
            LOAD_EN  : in  std_logic;
            SHIFT_EN : in  std_logic;
            CLK      : in  std_logic;
            RST      : in  std_logic;
            DATA     : out std_logic
        );
    end component PARALLEL_TO_SERIAL;

    signal DATA_IN   : std_logic_vector((DEPTH - 1) downto 0);
    signal LOAD_EN   : std_logic;
    signal SHIFT_EN  : std_logic;
    signal CLK       : std_logic;
    signal RST       : std_logic;
    signal DATA      : std_logic;
    signal TEST_DONE : std_logic := '0';

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

    dut : PARALLEL_TO_SERIAL
        generic map (
            data_size => DEPTH
        )
        port map (
            DATA_IN  => DATA_IN,
            LOAD_EN  => LOAD_EN,
            SHIFT_EN => SHIFT_EN,
            CLK      => CLK,
            RST      => RST,
            DATA     => DATA
        );

    test_proc : process is
    begin

        test_runner_setup(runner, runner_cfg);
        DATA_IN  <= "000";
        LOAD_EN  <= '0';
        SHIFT_EN <= '0';
        RST      <= '0';

        -- Reset system
        RST <= '1';
        wait for 1 ns;
        RST <= '0';

        run_clock(CLK);

        -- Load bytes
        LOAD_EN <= '1';
        DATA_IN <= "011";
        run_clock(CLK);
        check_equal(DATA, '0', "Loaded bytes");

        -- Test we just get zeros if SHIFT_EN is not set
        run_clock(CLK);
        check_equal(DATA, '0', "SHIFT_EN unset 1");
        run_clock(CLK);
        check_equal(DATA, '0', "SHIFT_EN unset 2");
        run_clock(CLK);
        check_equal(DATA, '0', "SHIFT_EN unset 3");

        -- Test we read bytes out as expected
        -- Setting LOAD_EN to '0' means that even though we
        -- changed DATA_IN, we persist what's in the shift reg
        LOAD_EN  <= '0';
        DATA_IN  <= "000";
        SHIFT_EN <= '1';
        run_clock(CLK);
        check_equal(DATA, '1', "First byte out correct");
        run_clock(CLK);
        check_equal(DATA, '1', "Second byte out correct");
        run_clock(CLK);
        check_equal(DATA, '0', "Third byte out correct");

        -- Test that we just get zeros if we keep trying
        run_clock(CLK);
        check_equal(DATA, '0', "Got zero 1");
        run_clock(CLK);
        check_equal(DATA, '0', "Got zero 2");
        run_clock(CLK);
        check_equal(DATA, '0', "Got zero 3");

        -- Test that if we load then reset, there's nothing in the shift reg
        SHIFT_EN <= '0';
        LOAD_EN  <= '1';
        DATA_IN  <= "111";
        run_clock(CLK);

        LOAD_EN <= '0';
        DATA_IN <= "000";
        RST     <= '1';
        wait for 1 ns;
        RST     <= '0';

        SHIFT_EN <= '1';
        run_clock(CLK);
        check_equal(DATA, '0', "Got zero after reset 1");
        run_clock(CLK);
        check_equal(DATA, '0', "Got zero after reset 2");
        run_clock(CLK);
        check_equal(DATA, '0', "Got zero after reset 3");
        run_clock(CLK);
        check_equal(DATA, '0', "Got zero after reset 4");

        -- Test that if LOAD_EN is zero, data is not loaded
        LOAD_EN  <= '0';
        SHIFT_EN <= '0';
        DATA_IN  <= "111";
        run_clock(CLK);

        DATA_IN  <= "000";
        SHIFT_EN <= '1';
        run_clock(CLK);
        check_equal(DATA, '0', "Got zero after LOAD_EN = '0' 1");
        run_clock(CLK);
        check_equal(DATA, '0', "Got zero after LOAD_EN = '0' 2");
        run_clock(CLK);
        check_equal(DATA, '0', "Got zero after LOAD_EN = '0' 3");
        run_clock(CLK);
        check_equal(DATA, '0', "Got zero after LOAD_EN = '0' 4");

        test_runner_cleanup(runner);

    end process test_proc;

end architecture TEST;