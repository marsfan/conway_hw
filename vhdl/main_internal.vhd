--- Internal portion of the main logic

-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https: //mozilla.org/MPL/2.0/.
library ieee;
use ieee.std_logic_1164.all;
entity MAIN_INTERNAL is
    port (
        INITIAL_IN : in std_logic_vector(63 downto 0);
        LOAD_RUN : in std_logic;
        WE : in std_logic;
        CLK : in std_logic;
        RESET : in std_logic;
        DATA_OUT : out std_logic_vector(63 downto 0)
    );
end MAIN_INTERNAL;

architecture RTL of MAIN_INTERNAL is

    component SYSTEM_MEMORY is
        generic (data_size : positive);
        port (
            INITIAL_IN   : in std_logic_vector((data_size-1) downto 0); -- Input from external word for initialization
            GRID_IN      : in std_logic_vector((data_size-1) downto 0); -- Input from the grid calculator
            WRITE_ENABLE : in std_logic; -- Enable writing to memory
            LOAD_RUN     : in std_logic; -- Whether we are in load mode or run mode. Used to select which input to read from
            CLK          : in std_logic; -- System clock
            RESET        : in std_logic; -- Asynchronous reset.

            MEM_OUT     : out std_logic_vector((data_size-1) downto 0) -- Memory output

        );
    end component SYSTEM_MEMORY;

    component CELL_GRID is
        port (
            INPUT_STATE : in std_logic_vector(63 downto 0);
            NEXT_STATE  : out std_logic_vector(63 downto 0)
        );
    end component CELL_GRID;

    signal MEM_OUT : std_logic_vector(63 downto 0);
    signal GRID_OUT : std_logic_vector(63 downto 0);

begin

    memory : SYSTEM_MEMORY
        generic map (data_size => 64)
        port map (
            INITIAL_IN => INITIAL_IN,
            GRID_IN => (others => '0'),
            WRITE_ENABLE => WE,
            LOAD_RUN => LOAD_RUN,
            CLK => CLK,
            RESET => RESET,
            MEM_OUT => MEM_OUT
        );

    grid : CELL_GRID
        port map (
            INPUT_STATE => MEM_OUT,
            NEXT_STATE => GRID_OUT
        );

    DATA_OUT <= GRID_OUT;



end architecture;