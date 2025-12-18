--- Check if alive and 2 or 3 neighbors are alive, or dead and 3 neighbors are alive.
library ieee;
use ieee.std_logic_1164.all;

entity NEIGHBOR_CHECK is
    port (
        ME    : in std_logic;
        N     : in std_logic;
        NE    : in std_logic;
        E     : in std_logic;
        SE    : in std_logic;
        S     : in std_logic;
        SW    : in std_logic;
        W     : in std_logic;
        NW    : in std_logic;
        IS_ALIVE : out std_logic
    );
end entity NEIGHBOR_CHECK;

architecture RTL of NEIGHBOR_CHECK is
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
    
end RTL;