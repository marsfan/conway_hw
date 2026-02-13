--- Grid of cell calculators for the entire system

-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https://mozilla.org/MPL/2.0/.

library ieee;
use ieee.std_logic_1164.all;

entity CELL_GRID is
    generic (
        grid_width  : positive;
        grid_height : positive
    );
    port (
        INPUT_STATE : in  std_logic_vector((grid_width * grid_height - 1) downto 0);
        NEXT_STATE  : out std_logic_vector((grid_width * grid_height - 1) downto 0)
    );
end entity CELL_GRID;

architecture RTL of CELL_GRID is

    component SINGLE_CELL is
        port (
            -- Current value of the cell
            ME : in  std_logic;

            -- Current states of neighboring cells
            N  : in  std_logic;
            NE : in  std_logic;
            E  : in  std_logic;
            SE : in  std_logic;
            S  : in  std_logic;
            SW : in  std_logic;
            W  : in  std_logic;
            NW : in  std_logic;

            -- New value of the cell
            IS_ALIVE : out std_logic
        );
    end component SINGLE_CELL;

    -- Create connection to INPUT_ARRAY if both X and Y are within
    -- The 0 and the grid width/height. If not, just return a constant '0'

    pure function create_connection (
        INPUT_ARRAY : std_logic_vector((grid_width * grid_height - 1) downto 0);
        X : integer;
        Y : integer
    ) return std_logic is
    begin

        if X >= 0 AND Y >= 0 AND X < grid_width AND Y < grid_height then
            return INPUT_ARRAY((grid_width * Y) + X);
        else
            return '0';
        end if;

    end function create_connection;

begin

    gen_x : for x in (grid_width - 1) downto 0 generate

        gen_y : for y in (grid_height - 1) downto 0 generate

        begin

            cell : SINGLE_CELL
                port map (
                    ME       => INPUT_STATE(grid_width * y + x),
                    N        => create_connection(INPUT_STATE, x,     y - 1),
                    NE       => create_connection(INPUT_STATE, x + 1, y - 1),
                    E        => create_connection(INPUT_STATE, x + 1, y),
                    SE       => create_connection(INPUT_STATE, x + 1, y + 1),
                    S        => create_connection(INPUT_STATE, x,     y + 1),
                    SW       => create_connection(INPUT_STATE, x - 1, y + 1),
                    W        => create_connection(INPUT_STATE, x - 1, y),
                    NW       => create_connection(INPUT_STATE, x - 1, y - 1),
                    IS_ALIVE => NEXT_STATE(grid_width * y + x)
                );

        end generate gen_y;

    end generate gen_x;

end architecture RTL;