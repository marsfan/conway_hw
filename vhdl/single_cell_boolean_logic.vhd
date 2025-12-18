--- Logic for computing next value of a single cell in the system.
--- There are 4 rules for computing the next state of the cell
---  1. If currently alive and less than 2 neighbors alive, dies (underpopulation)
---  2. If currently alive and 2 or 3 neighbors, lives
---  3. If currently alive and more than 3 neighbors, dies (overpopulation)
---  4. If currently dead and exactly three neighbors alive, lives (reproduction)
---
--- Since are computing when alive, we can just check rules 2 and 4. And assume all
--- other conditions are dead

-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at https: //mozilla.org/MPL/2.0/.
library ieee;
use ieee.std_logic_1164.all;

entity SINGLE_CELL_BOOLEAN_LOGIC is
    port (
        -- Current value of the cell
        ME    : in std_logic;

        -- Current states of neighboring cells
        N     : in std_logic;
        NE    : in std_logic;
        E     : in std_logic;
        SE    : in std_logic;
        S     : in std_logic;
        SW    : in std_logic;
        W     : in std_logic;
        NW    : in std_logic;

        -- New value of the cell
        IS_ALIVE : out std_logic
    );
end SINGLE_CELL_BOOLEAN_LOGIC;


architecture RTL of SINGLE_CELL_BOOLEAN_LOGIC is
begin


IS_ALIVE <= ME
    AND (E OR N OR NE OR NW OR S OR SE OR SW)
    AND (E OR N OR NE OR NW OR S OR SE OR W)
    AND (E OR N OR NE OR NW OR S OR SW OR W)
    AND (E OR N OR NE OR NW OR SE OR SW OR W)
    AND (E OR N OR NE OR S OR SE OR SW OR W)
    AND (E OR N OR NW OR S OR SE OR SW OR W)
    AND (E OR NE OR NW OR S OR SE OR SW OR W)
    AND (N OR NE OR NW OR S OR SE OR SW OR W)
    AND ((NOT E) OR (NOT N) OR (NOT NE) OR (NOT NW))
    AND ((NOT E) OR (NOT N) OR (NOT NE) OR (NOT S))
    AND ((NOT E) OR (NOT N) OR (NOT NE) OR (NOT SE))
    AND ((NOT E) OR (NOT N) OR (NOT NE) OR (NOT SW))
    AND ((NOT E) OR (NOT N) OR (NOT NE) OR (NOT W))
    AND ((NOT E) OR (NOT N) OR (NOT NW) OR (NOT S))
    AND ((NOT E) OR (NOT N) OR (NOT NW) OR (NOT SE))
    AND ((NOT E) OR (NOT N) OR (NOT NW) OR (NOT SW))
    AND ((NOT E) OR (NOT N) OR (NOT NW) OR (NOT W))
    AND ((NOT E) OR (NOT N) OR (NOT S) OR (NOT SE))
    AND ((NOT E) OR (NOT N) OR (NOT S) OR (NOT SW))
    AND ((NOT E) OR (NOT N) OR (NOT S) OR (NOT W))
    AND ((NOT E) OR (NOT N) OR (NOT SE) OR (NOT SW))
    AND ((NOT E) OR (NOT N) OR (NOT SE) OR (NOT W))
    AND ((NOT E) OR (NOT N) OR (NOT SW) OR (NOT W))
    AND ((NOT E) OR (NOT NE) OR (NOT NW) OR (NOT S))
    AND ((NOT E) OR (NOT NE) OR (NOT NW) OR (NOT SE))
    AND ((NOT E) OR (NOT NE) OR (NOT NW) OR (NOT SW))
    AND ((NOT E) OR (NOT NE) OR (NOT NW) OR (NOT W))
    AND ((NOT E) OR (NOT NE) OR (NOT S) OR (NOT SE))
    AND ((NOT E) OR (NOT NE) OR (NOT S) OR (NOT SW))
    AND ((NOT E) OR (NOT NE) OR (NOT S) OR (NOT W))
    AND ((NOT E) OR (NOT NE) OR (NOT SE) OR (NOT SW))
    AND ((NOT E) OR (NOT NE) OR (NOT SE) OR (NOT W))
    AND ((NOT E) OR (NOT NE) OR (NOT SW) OR (NOT W))
    AND ((NOT E) OR (NOT NW) OR (NOT S) OR (NOT SE))
    AND ((NOT E) OR (NOT NW) OR (NOT S) OR (NOT SW))
    AND ((NOT E) OR (NOT NW) OR (NOT S) OR (NOT W))
    AND ((NOT E) OR (NOT NW) OR (NOT SE) OR (NOT SW))
    AND ((NOT E) OR (NOT NW) OR (NOT SE) OR (NOT W))
    AND ((NOT E) OR (NOT NW) OR (NOT SW) OR (NOT W))
    AND ((NOT E) OR (NOT S) OR (NOT SE) OR (NOT SW))
    AND ((NOT E) OR (NOT S) OR (NOT SE) OR (NOT W))
    AND ((NOT E) OR (NOT S) OR (NOT SW) OR (NOT W))
    AND ((NOT E) OR (NOT SE) OR (NOT SW) OR (NOT W))
    AND ((NOT N) OR (NOT NE) OR (NOT NW) OR (NOT S))
    AND ((NOT N) OR (NOT NE) OR (NOT NW) OR (NOT SE))
    AND ((NOT N) OR (NOT NE) OR (NOT NW) OR (NOT SW))
    AND ((NOT N) OR (NOT NE) OR (NOT NW) OR (NOT W))
    AND ((NOT N) OR (NOT NE) OR (NOT S) OR (NOT SE))
    AND ((NOT N) OR (NOT NE) OR (NOT S) OR (NOT SW))
    AND ((NOT N) OR (NOT NE) OR (NOT S) OR (NOT W))
    AND ((NOT N) OR (NOT NE) OR (NOT SE) OR (NOT SW))
    AND ((NOT N) OR (NOT NE) OR (NOT SE) OR (NOT W))
    AND ((NOT N) OR (NOT NE) OR (NOT SW) OR (NOT W))
    AND ((NOT N) OR (NOT NW) OR (NOT S) OR (NOT SE))
    AND ((NOT N) OR (NOT NW) OR (NOT S) OR (NOT SW))
    AND ((NOT N) OR (NOT NW) OR (NOT S) OR (NOT W))
    AND ((NOT N) OR (NOT NW) OR (NOT SE) OR (NOT SW))
    AND ((NOT N) OR (NOT NW) OR (NOT SE) OR (NOT W))
    AND ((NOT N) OR (NOT NW) OR (NOT SW) OR (NOT W))
    AND ((NOT N) OR (NOT S) OR (NOT SE) OR (NOT SW))
    AND ((NOT N) OR (NOT S) OR (NOT SE) OR (NOT W))
    AND ((NOT N) OR (NOT S) OR (NOT SW) OR (NOT W))
    AND ((NOT N) OR (NOT SE) OR (NOT SW) OR (NOT W))
    AND ((NOT NE) OR (NOT NW) OR (NOT S) OR (NOT SE))
    AND ((NOT NE) OR (NOT NW) OR (NOT S) OR (NOT SW))
    AND ((NOT NE) OR (NOT NW) OR (NOT S) OR (NOT W))
    AND ((NOT NE) OR (NOT NW) OR (NOT SE) OR (NOT SW))
    AND ((NOT NE) OR (NOT NW) OR (NOT SE) OR (NOT W))
    AND ((NOT NE) OR (NOT NW) OR (NOT SW) OR (NOT W))
    AND ((NOT NE) OR (NOT S) OR (NOT SE) OR (NOT SW))
    AND ((NOT NE) OR (NOT S) OR (NOT SE) OR (NOT W))
    AND ((NOT NE) OR (NOT S) OR (NOT SW) OR (NOT W))
    AND ((NOT NE) OR (NOT SE) OR (NOT SW) OR (NOT W))
    AND ((NOT NW) OR (NOT S) OR (NOT SE) OR (NOT SW))
    AND ((NOT NW) OR (NOT S) OR (NOT SE) OR (NOT W))
    AND ((NOT NW) OR (NOT S) OR (NOT SW) OR (NOT W))
    AND ((NOT NW) OR (NOT SE) OR (NOT SW) OR (NOT W))
    AND ((NOT S) OR (NOT SE) OR (NOT SW) OR (NOT W));

end architecture RTL;