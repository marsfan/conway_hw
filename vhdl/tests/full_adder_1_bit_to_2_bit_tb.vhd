-- Testbench for the FULL_ADDER_1_BIT_TO_2_BIT entity
-- Based on the example in the GHDL documentation
-- https://ghdl.github.io/ghdl/quick_start/simulation/adder/index.html

-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

library ieee;
use ieee.std_logic_1164.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity FULL_ADDER_1_BIT_TO_2_BIT_TB is
    generic (
        runner_cfg : string
    );
end entity FULL_ADDER_1_BIT_TO_2_BIT_TB;

architecture TEST of FULL_ADDER_1_BIT_TO_2_BIT_TB is

    component FULL_ADDER_1_BIT_TO_2_BIT is
        port (
            A   : in  std_logic;
            B   : in  std_logic;
            SUM : out std_logic_vector(1 downto 0)
        );
    end component FULL_ADDER_1_BIT_TO_2_BIT;

    signal A   : std_logic;
    signal B   : std_logic;
    signal SUM : std_logic_vector(1 downto 0);

begin

    test_adder : FULL_ADDER_1_BIT_TO_2_BIT
        port map (
            A   => A,
            B   => B,
            SUM => SUM
        );

    test_proc : process is
    begin

        test_runner_setup(runner, runner_cfg);

        if run("TEST_FULL_ADDER_1_BIT_TO_2_BIT") then
            A <= '0';
            B <= '0';
            wait for 1 ns;
            check_equal(SUM, 0, "SUM_00");

            A <= '1';
            B <= '0';
            wait for 1 ns;
            check_equal(SUM, 1, "SUM_01");

            A <= '0';
            B <= '1';
            wait for 1 ns;
            check_equal(SUM, 1, "SUM_01_2");

            A <= '1';
            B <= '1';
            wait for 1 ns;
            check_equal(SUM, 2, "SUM_10");
        end if;

        test_runner_cleanup(runner);

    end process test_proc;

end architecture TEST;