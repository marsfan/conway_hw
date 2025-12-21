--- Memory for the system

-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https: //mozilla.org/MPL/2.0/.

library ieee;
use ieee.std_logic_1164.all;

entity SYSTEM_MEMORY is
    generic (
        data_size : positive
    );
    port (
        INITIAL_IN   : in  std_logic_vector((data_size - 1) downto 0); -- Input from external word for initialization
        GRID_IN      : in  std_logic_vector((data_size - 1) downto 0); -- Input from the grid calculator
        WRITE_ENABLE : in  std_logic; -- Enable writing to memory
        LOAD_RUN     : in  std_logic; -- Whether we are in load mode or run mode. Used to select input to read from
        CLK          : in  std_logic; -- System clock
        RESET        : in  std_logic; -- Asynchronous reset.
        MEM_OUT      : out std_logic_vector((data_size - 1) downto 0) -- Memory output
    );
end entity SYSTEM_MEMORY;

architecture RTL of SYSTEM_MEMORY is

    component REG is
        generic (
            width : positive
        );
        port (
            D     : in  std_logic_vector((width - 1) downto 0);
            WE    : in  std_logic;
            CLK   : in  std_logic;
            RESET : in  std_logic;
            Q     : out std_logic_vector((width - 1) downto 0)
        );
    end component REG;

    signal MEM_IN : std_logic_vector((data_size - 1) downto 0);

begin

    -- Mux to select input source
    MEM_IN <= INITIAL_IN when LOAD_RUN = '0' else
              GRID_IN;

    memory : REG
        generic map (
            width => data_size
        )
        port map (
            D     => MEM_IN,
            WE    => WRITE_ENABLE,
            CLK   => CLK,
            RESET => RESET,
            Q     => MEM_OUT
        );

end architecture RTL;