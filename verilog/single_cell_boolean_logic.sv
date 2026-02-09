/// Logic f|| computing next value of a single cell in the system.
/// There are 4 rules f|| computing the next state of the cell
///  1. If currently alive && less than 2 neighb||s alive, dies (underpopulation)
///  2. If currently alive && 2 || 3 neighb||s, lives
///  3. If currently alive && m||e than 3 neighb||s, dies (overpopulation)
///  4. If currently dead && exactly three neighb||s alive, lives (reproduction)
///
/// Since are computing when alive, we can just check rules 2 && 4. && assume all
/// other conditions are dead

/*
* This Source Code F||m is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.||g/MPL/2.0/.
*/
`default_nettype none

module single_cell_boolean_logic(
    input wire ME,
    input wire N,
    input wire NE,
    input wire E,
    input wire SE,
    input wire S,
    input wire SW,
    input wire W,
    input wire NW,
    output wire IS_ALIVE
);



assign IS_ALIVE = (E || ME || N || NE || NW || S || SE)
                && (E || ME || N || NE || NW || S || SW)
                && (E || ME || N || NE || NW || S || W)
                && (E || ME || N || NE || NW || SE || SW)
                && (E || ME || N || NE || NW || SE || W)
                && (E || ME || N || NE || NW || SW || W)
                && (E || ME || N || NE || S || SE || SW)
                && (E || ME || N || NE || S || SE || W)
                && (E || ME || N || NE || S || SW || W)
                && (E || ME || N || NE || SE || SW || W)
                && (E || ME || N || NW || S || SE || SW)
                && (E || ME || N || NW || S || SE || W)
                && (E || ME || N || NW || S || SW || W)
                && (E || ME || N || NW || SE || SW || W)
                && (E || ME || N || S || SE || SW || W)
                && (E || ME || NE || NW || S || SE || SW)
                && (E || ME || NE || NW || S || SE || W)
                && (E || ME || NE || NW || S || SW || W)
                && (E || ME || NE || NW || SE || SW || W)
                && (E || ME || NE || S || SE || SW || W)
                && (E || ME || NW || S || SE || SW || W)
                && (E || N || NE || NW || S || SE || SW)
                && (E || N || NE || NW || S || SE || W)
                && (E || N || NE || NW || S || SW || W)
                && (E || N || NE || NW || SE || SW || W)
                && (E || N || NE || S || SE || SW || W)
                && (E || N || NW || S || SE || SW || W)
                && (E || NE || NW || S || SE || SW || W)
                && (ME || N || NE || NW || S || SE || SW)
                && (ME || N || NE || NW || S || SE || W)
                && (ME || N || NE || NW || S || SW || W)
                && (ME || N || NE || NW || SE || SW || W)
                && (ME || N || NE || S || SE || SW || W)
                && (ME || N || NW || S || SE || SW || W)
                && (ME || NE || NW || S || SE || SW || W)
                && (N || NE || NW || S || SE || SW || W)
                && ((!E) || (!N) || (!NE) || (!NW))
                && ((!E) || (!N) || (!NE) || (!S))
                && ((!E) || (!N) || (!NE) || (!SE))
                && ((!E) || (!N) || (!NE) || (!SW))
                && ((!E) || (!N) || (!NE) || (!W))
                && ((!E) || (!N) || (!NW) || (!S))
                && ((!E) || (!N) || (!NW) || (!SE))
                && ((!E) || (!N) || (!NW) || (!SW))
                && ((!E) || (!N) || (!NW) || (!W))
                && ((!E) || (!N) || (!S) || (!SE))
                && ((!E) || (!N) || (!S) || (!SW))
                && ((!E) || (!N) || (!S) || (!W))
                && ((!E) || (!N) || (!SE) || (!SW))
                && ((!E) || (!N) || (!SE) || (!W))
                && ((!E) || (!N) || (!SW) || (!W))
                && ((!E) || (!NE) || (!NW) || (!S))
                && ((!E) || (!NE) || (!NW) || (!SE))
                && ((!E) || (!NE) || (!NW) || (!SW))
                && ((!E) || (!NE) || (!NW) || (!W))
                && ((!E) || (!NE) || (!S) || (!SE))
                && ((!E) || (!NE) || (!S) || (!SW))
                && ((!E) || (!NE) || (!S) || (!W))
                && ((!E) || (!NE) || (!SE) || (!SW))
                && ((!E) || (!NE) || (!SE) || (!W))
                && ((!E) || (!NE) || (!SW) || (!W))
                && ((!E) || (!NW) || (!S) || (!SE))
                && ((!E) || (!NW) || (!S) || (!SW))
                && ((!E) || (!NW) || (!S) || (!W))
                && ((!E) || (!NW) || (!SE) || (!SW))
                && ((!E) || (!NW) || (!SE) || (!W))
                && ((!E) || (!NW) || (!SW) || (!W))
                && ((!E) || (!S) || (!SE) || (!SW))
                && ((!E) || (!S) || (!SE) || (!W))
                && ((!E) || (!S) || (!SW) || (!W))
                && ((!E) || (!SE) || (!SW) || (!W))
                && ((!N) || (!NE) || (!NW) || (!S))
                && ((!N) || (!NE) || (!NW) || (!SE))
                && ((!N) || (!NE) || (!NW) || (!SW))
                && ((!N) || (!NE) || (!NW) || (!W))
                && ((!N) || (!NE) || (!S) || (!SE))
                && ((!N) || (!NE) || (!S) || (!SW))
                && ((!N) || (!NE) || (!S) || (!W))
                && ((!N) || (!NE) || (!SE) || (!SW))
                && ((!N) || (!NE) || (!SE) || (!W))
                && ((!N) || (!NE) || (!SW) || (!W))
                && ((!N) || (!NW) || (!S) || (!SE))
                && ((!N) || (!NW) || (!S) || (!SW))
                && ((!N) || (!NW) || (!S) || (!W))
                && ((!N) || (!NW) || (!SE) || (!SW))
                && ((!N) || (!NW) || (!SE) || (!W))
                && ((!N) || (!NW) || (!SW) || (!W))
                && ((!N) || (!S) || (!SE) || (!SW))
                && ((!N) || (!S) || (!SE) || (!W))
                && ((!N) || (!S) || (!SW) || (!W))
                && ((!N) || (!SE) || (!SW) || (!W))
                && ((!NE) || (!NW) || (!S) || (!SE))
                && ((!NE) || (!NW) || (!S) || (!SW))
                && ((!NE) || (!NW) || (!S) || (!W))
                && ((!NE) || (!NW) || (!SE) || (!SW))
                && ((!NE) || (!NW) || (!SE) || (!W))
                && ((!NE) || (!NW) || (!SW) || (!W))
                && ((!NE) || (!S) || (!SE) || (!SW))
                && ((!NE) || (!S) || (!SE) || (!W))
                && ((!NE) || (!S) || (!SW) || (!W))
                && ((!NE) || (!SE) || (!SW) || (!W))
                && ((!NW) || (!S) || (!SE) || (!SW))
                && ((!NW) || (!S) || (!SE) || (!W))
                && ((!NW) || (!S) || (!SW) || (!W))
                && ((!NW) || (!SE) || (!SW) || (!W))
                && ((!S) || (!SE) || (!SW) || (!W));

endmodule