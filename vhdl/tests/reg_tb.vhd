-- Testbench for reg entity
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity REG_TB is
    generic (runner_cfg : string);
end REG_TB;

architecture TEST of REG_TB is
    constant width : positive := 11;
    constant clock_period : time := 20 ns;

    -- Declare we are using the REG component
    component REG is
            generic (width : positive);
    port (
        D     : in std_logic_vector((width - 1) downto 0);
        WE    : in std_logic;
        CLK   : in std_logic;
        RESET : in std_logic;
        Q     : out std_logic_vector((width - 1) downto 0)
    );
    end component;

    signal CLK, RESET, WE : std_logic;
    signal D, Q           : std_logic_vector((width - 1) downto 0);
    signal TEST_DONE      : std_logic := '0';
begin

-- Instantiate the register component
    TEST_REG: REG generic map(11)
              port map ( D => D,
                         WE => WE,
                         CLK => CLK,
                         RESET => RESET,
                         Q => Q );

-- Process for running the clock signal
clock_process : process
begin
    CLK <= '0';
    wait for clock_period/2;
    CLK <= '1';
    wait for clock_period/2;

    if TEST_DONE = '1' then
        -- End the process if TEST_DONE signal is set.
        assert false report "end of test" severity note;
        wait;
    end if;
end process;

-- Process for the actual tests
-- NOTE: If we enable VHDL2008 we can get the to_string function for std_logic_vector
-- Makes reporting look nice
reg_test_proc : process
begin
    test_runner_setup(runner, runner_cfg);
    -- Reset register
    RESET <= '1';
    wait for 1 ns;
    assert (Q = "00000000000") report "Reset Failed" severity error;

    -- Clear the reset flag
    RESET <= '0';

    -- Set D to 0, but don't enable WE.
    D <= "00000001100";
    wait for 1 ns;
    wait for clock_period;
    -- Check that Q did not change since WE was not set
    assert (Q = "00000000000") report "Q Stay the same Failed." severity error;

    -- Enable WE so that Q is now set
    WE <= '1';
    wait for clock_period;
    assert (Q = "00000001100") report "Q Set Failed" severity error;

    -- Disable WE and make sure Q stays set
    WE <= '1';
    wait for clock_period;
    assert (Q = "00000001100") report "Q Stays the same failed" severity error;

    -- Set the TEST_DONE signal to end the clocking while loop.
    TEST_DONE <= '1';
    test_runner_cleanup(runner);
end process;

end TEST;