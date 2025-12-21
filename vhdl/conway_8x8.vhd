--- 8X8 conway's game of life implementation

-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https: //mozilla.org/MPL/2.0/.

library ieee;
use ieee.std_logic_1164.all;

entity CONWAY_8X8 is
    port (
        INITIAL_STATE : in  std_logic_vector(63 downto 0); -- Input state to load system with
        CLK           : in  std_logic; -- System Clock
        CLK_EN        : in  std_logic; -- Gate for enabling clock to system
        LOAD_RUN      : in  std_logic; -- Whether to load memory from initial state, or start running
        CURRENT_STATE : out std_logic_vector(63 downto 0); -- Output for displaying the state currently in memory
        NEXT_STATE    : out std_logic_vector(63 downto 0)  -- Output for displaying the next state to put into memory
    );
end entity CONWAY_8X8;

architecture RTL of CONWAY_8X8 is

    component CELL_GRID is
        port (
            INPUT_STATE : in  std_logic_vector(63 downto 0);
            NEXT_STATE  : out std_logic_vector(63 downto 0)
        );
    end component CELL_GRID;

    component REG is
        generic (
            width : positive := 1
        );
        port (
            D     : in  std_logic_vector((width - 1) downto 0);
            WE    : in  std_logic;
            CLK   : in  std_logic;
            RESET : in  std_logic;
            Q     : out std_logic_vector((width - 1) downto 0)
        );
    end component REG;

    signal GATED_CLK : std_logic;
    signal MEM_IN    : std_logic_vector(63 downto 0);
    signal MEM_OUT   : std_logic_vector(63 downto 0);
    signal GRID_IN   : std_logic_vector(63 downto 0);
    signal GRID_OUT  : std_logic_vector(63 downto 0);

begin

    GATED_CLK <= CLK AND CLK_EN;

    MEM_IN <= INITIAL_STATE when LOAD_RUN = '0' else GRID_OUT;

    memory : REG
        generic map (
            width => 64
        )
        port map (
            D     => MEM_IN,
            WE    => '1',
            CLK   => GATED_CLK,
            RESET => '0',
            Q     => MEM_OUT
        );

    GRID_IN <= INITIAL_STATE when LOAD_RUN = '0' else MEM_OUT;

    grid : CELL_GRID
        port map (
            INPUT_STATE => GRID_IN,
            NEXT_STATE  => GRID_OUT
        );

    CURRENT_STATE <= GRID_IN;
    NEXT_STATE    <= GRID_OUT;

end architecture RTL;