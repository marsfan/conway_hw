--- Testbench for the DECODER entity

-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https: //mozilla.org/MPL/2.0/.

library ieee;
use ieee.std_logic_1164.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity DECODER_TB is
    generic (
        runner_cfg : string
    );
end entity DECODER_TB;

architecture TEST of DECODER_TB is

    component DECODER is
        port (
            VAL_IN : in  std_logic_vector(1 downto 0);
            VAL_00 : out std_logic;
            VAL_01 : out std_logic;
            VAL_10 : out std_logic;
            VAL_11 : out std_logic
        );
    end component DECODER;

    signal VAL_IN : std_logic_vector(1 downto 0);
    signal VAL_00 : std_logic;
    signal VAL_01 : std_logic;
    signal VAL_10 : std_logic;
    signal VAL_11 : std_logic;

    -- Array of test cases to evaluate

    type test_record is record
        VAL_IN : std_logic_vector(1 downto 0);
        VAL_00 : std_logic;
        VAL_01 : std_logic;
        VAL_10 : std_logic;
        VAL_11 : std_logic;
    end record test_record;

    type test_array_t is array (natural range <>) of test_record;

    constant TEST_ARRAY : test_array_t := (
        ("00", '1', '0', '0', '0'),
        ("01", '0', '1', '0', '0'),
        ("10", '0', '0', '1', '0'),
        ("11", '0', '0', '0', '1')
    );

begin

    -- Instantiate the  component
    test_dec : DECODER
        port map (
            VAL_IN => VAL_IN,
            VAL_00 => VAL_00,
            VAL_01 => VAL_01,
            VAL_10 => VAL_10,
            VAL_11 => VAL_11
        );

    -- Process for the actual tests
    -- NOTE: If we enable VHDL2008 we can get the to_string function for std_logic_vector
    -- Makes reporting look nice
    test_proc : process is
    begin

        test_runner_setup(runner, runner_cfg);

        if run("TEST_DECODER") then

            for i in TEST_ARRAY'range loop

                -- Set input
                VAL_IN <= TEST_ARRAY(i).VAL_IN;

                wait for 1 ns;
                -- Check outputs
                check_equal(VAL_00, TEST_ARRAY(i).VAL_00, "VAL00");
                check_equal(VAL_01, TEST_ARRAY(i).VAL_01, "VAL01");
                check_equal(VAL_10, TEST_ARRAY(i).VAL_10, "VAL10");
                check_equal(VAL_11, TEST_ARRAY(i).VAL_11, "VAL11");

            end loop;

        end if;

        test_runner_cleanup(runner);

    end process test_proc;

end architecture TEST;