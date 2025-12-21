-- Testbench for the FULL_ADDER_2_BIT_TO_3_BIT entity
-- Based on the example in the GHDL documentation
-- https://ghdl.github.io/ghdl/quick_start/simulation/adder/index.html

-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https: //mozilla.org/MPL/2.0/.

library ieee;
use ieee.std_logic_1164.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity FULL_ADDER_2_BIT_TO_3_BIT_TB is
    generic (
        runner_cfg : string
    );
end entity FULL_ADDER_2_BIT_TO_3_BIT_TB;

architecture TEST of FULL_ADDER_2_BIT_TO_3_BIT_TB is

    component FULL_ADDER_2_BIT_TO_3_BIT is
        port (
            A   : in  std_logic_vector(1 downto 0);
            B   : in  std_logic_vector(1 downto 0);
            SUM : out std_logic_vector(2 downto 0)
        );
    end component FULL_ADDER_2_BIT_TO_3_BIT;

    signal A   : std_logic_vector(1 downto 0);
    signal B   : std_logic_vector(1 downto 0);
    signal SUM : std_logic_vector(2 downto 0);

    type test_record is record
        A   : std_logic_vector(1 downto 0);
        B   : std_logic_vector(1 downto 0);
        SUM : std_logic_vector(2 downto 0);
    end record test_record;

    type test_array_t is array (natural range <>) of test_record;

    constant TEST_ARRAY : test_array_t := (
        ("00", "00", "000"),
        ("01", "00", "001"),
        ("10", "00", "010"),
        ("11", "00", "011"),

        ("00", "01", "001"),
        ("01", "01", "010"),
        ("10", "01", "011"),
        ("11", "01", "100"),

        ("00", "10", "010"),
        ("01", "10", "011"),
        ("10", "10", "100"),
        ("11", "10", "101"),

        ("00", "11", "011"),
        ("01", "11", "100"),
        ("10", "11", "101"),
        ("11", "11", "110")
    );

begin

    test_adder : FULL_ADDER_2_BIT_TO_3_BIT
        port map (
            A   => A,
            B   => B,
            SUM => SUM
        );

    test_proc : process is
    begin

        test_runner_setup(runner, runner_cfg);

        if run("TEST_FULL_ADDER_2_BIT_TO_3_BIT") then

            for i in TEST_ARRAY'range loop

                A <= TEST_ARRAY(i).A;
                B <= TEST_ARRAY(i).B;
                wait for 1 ns;
                check_equal(SUM, TEST_ARRAY(i).SUM);

            end loop;

        end if;

        test_runner_cleanup(runner);

    end process test_proc;

end architecture TEST;