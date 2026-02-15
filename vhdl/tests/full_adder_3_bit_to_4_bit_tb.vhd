-- Testbench for the FULL_ADDER_3_BIT_TO_4_BIT entity
-- Based on the example in the GHDL documentation
-- https://ghdl.github.io/ghdl/quick_start/simulation/adder/index.html

-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

library ieee;
use ieee.std_logic_1164.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity FULL_ADDER_3_BIT_TO_4_BIT_TB is
    generic (
        runner_cfg : string
    );
end entity FULL_ADDER_3_BIT_TO_4_BIT_TB;

architecture TEST of FULL_ADDER_3_BIT_TO_4_BIT_TB is

    component FULL_ADDER_3_BIT_TO_4_BIT is
        port (
            A   : in  std_logic_vector(2 downto 0);
            B   : in  std_logic_vector(2 downto 0);
            SUM : out std_logic_vector(3 downto 0)
        );
    end component FULL_ADDER_3_BIT_TO_4_BIT;

    signal A   : std_logic_vector(2 downto 0);
    signal B   : std_logic_vector(2 downto 0);
    signal SUM : std_logic_vector(3 downto 0);

    type test_record is record
        A   : std_logic_vector(2 downto 0);
        B   : std_logic_vector(2 downto 0);
        SUM : std_logic_vector(3 downto 0);
    end record test_record;

    type test_array_t is array (natural range <>) of test_record;

    constant TEST_ARRAY : test_array_t := (
        ("000", "000", "0000"),
        ("001", "000", "0001"),
        ("010", "000", "0010"),
        ("011", "000", "0011"),
        ("100", "000", "0100"),
        ("101", "000", "0101"),
        ("110", "000", "0110"),
        ("111", "000", "0111"),

        ("000", "001", "0001"),
        ("001", "001", "0010"),
        ("010", "001", "0011"),
        ("011", "001", "0100"),
        ("100", "001", "0101"),
        ("101", "001", "0110"),
        ("110", "001", "0111"),
        ("111", "001", "1000"),

        ("000", "010", "0010"),
        ("001", "010", "0011"),
        ("010", "010", "0100"),
        ("011", "010", "0101"),
        ("100", "010", "0110"),
        ("101", "010", "0111"),
        ("110", "010", "1000"),
        ("111", "010", "1001"),

        ("000", "011", "0011"),
        ("001", "011", "0100"),
        ("010", "011", "0101"),
        ("011", "011", "0110"),
        ("100", "011", "0111"),
        ("101", "011", "1000"),
        ("110", "011", "1001"),
        ("111", "011", "1010"),

        ("000", "100", "0100"),
        ("001", "100", "0101"),
        ("010", "100", "0110"),
        ("011", "100", "0111"),
        ("100", "100", "1000"),
        ("101", "100", "1001"),
        ("110", "100", "1010"),
        ("111", "100", "1011"),

        ("000", "101", "0101"),
        ("001", "101", "0110"),
        ("010", "101", "0111"),
        ("011", "101", "1000"),
        ("100", "101", "1001"),
        ("101", "101", "1010"),
        ("110", "101", "1011"),
        ("111", "101", "1100"),

        ("000", "110", "0110"),
        ("001", "110", "0111"),
        ("010", "110", "1000"),
        ("011", "110", "1001"),
        ("100", "110", "1010"),
        ("101", "110", "1011"),
        ("110", "110", "1100"),
        ("111", "110", "1101"),

        ("000", "111", "0111"),
        ("001", "111", "1000"),
        ("010", "111", "1001"),
        ("011", "111", "1010"),
        ("100", "111", "1011"),
        ("101", "111", "1100"),
        ("110", "111", "1101"),
        ("111", "111", "1110")
    );

begin

    test_adder : FULL_ADDER_3_BIT_TO_4_BIT
        port map (
            A   => A,
            B   => B,
            SUM => SUM
        );

    test_proc : process is
    begin

        test_runner_setup(runner, runner_cfg);

        if run("TEST_FULL_ADDER_3_BIT_TO_4_BIT") then

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