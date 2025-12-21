-- Testbench for the FULL_ADDER entity
-- Based on the example in the GHDL documentation
-- https://ghdl.github.io/ghdl/quick_start/simulation/adder/index.html

-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https: //mozilla.org/MPL/2.0/.

library ieee;
use ieee.std_logic_1164.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity FULL_ADDER_TB is
    generic (
        runner_cfg : string
    );
end entity FULL_ADDER_TB;

architecture TEST of FULL_ADDER_TB is

    component FULL_ADDER is
        port (
            A     : in  std_logic;
            B     : in  std_logic;
            C_IN  : in  std_logic;
            SUM   : out std_logic;
            CARRY : out std_logic
        );
    end component FULL_ADDER;

    -- Array of test cases to evaluate

    type test_record is record
        A1   : std_logic;
        A2   : std_logic;
        CIN  : std_logic;
        COUT : std_logic;
        SUM  : std_logic;
    end record test_record;

    type test_array_t is array (natural range <>) of test_record;

    constant TEST_ARRAY : test_array_t := (
        ('0', '0', '0', '0', '0'),
        ('0', '0', '1', '0', '1'),
        ('0', '1', '0', '0', '1'),
        ('0', '1', '1', '1', '0'),
        ('1', '0', '0', '0', '1'),
        ('1', '0', '1', '1', '0'),
        ('1', '1', '0', '1', '0'),
        ('1', '1', '1', '1', '1')
    );

    signal IN1  : std_logic_vector;
    signal IN2  : std_logic_vector;
    signal CIN  : std_logic_vector;
    signal SUM  : std_logic_vector;
    signal COUT : std_logic := '0';

begin

    test_adder : FULL_ADDER
        port map (
            A     => IN1,
            B     => IN2,
            C_IN  => CIN,
            SUM   => SUM,
            CARRY => COUT
        );

    test_proc : process is
    begin

        test_runner_setup(runner, runner_cfg);

        if run("TEST_ADDER") then

            for i in TEST_ARRAY'range loop

                -- Set all signals
                IN1 <= TEST_ARRAY(i).A1;
                IN2 <= TEST_ARRAY(i).A2;
                CIN <= TEST_ARRAY(i).CIN;
                wait for 1 ns;
                check_equal(SUM, TEST_ARRAY(i).SUM, "SUM");
                check_equal(COUT, TEST_ARRAY(i).COUT, "COUT");

            end loop;

        end if;

        test_runner_cleanup(runner);

    end process test_proc;

end architecture TEST;