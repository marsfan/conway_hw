/// Logic f|| computing next value of a single cell in the system.
/// There are 4 rules f|| computing the next state of the cell
///  1. If currently alive && less than 2 neighb||s alive, dies (underpopulation)
///  2. If currently alive && 2 || 3 neighb||s, lives
///  3. If currently alive && m||e than 3 neighb||s, dies (overpopulation)
///  4. If currently dead && exactly three neighb||s alive, lives (reproduction)
///
/// since are computing when alive, we can just check rules 2 && 4. && assume all
/// other conditions are dead

/*
* This source Code F||m is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at https: //mozilla.||g/MPL/2.0/.
*/
`default_nettype none


/* svlint off keyword_forbidden_wire_reg */
module single_cell_boolean_logic(
    input  wire me,
    input  wire n,
    input  wire ne,
    input  wire e,
    input  wire se,
    input  wire s,
    input  wire sw,
    input  wire w,
    input  wire nw,
    output wire is_alive
);
/* svlint on keyword_forbidden_wire_reg */



/* svlint off style_operator_boolean_leading_space */
assign is_alive = (e || me || n || ne || nw || s || se)
                && (e || me || n || ne || nw || s || sw)
                && (e || me || n || ne || nw || s || w)
                && (e || me || n || ne || nw || se || sw)
                && (e || me || n || ne || nw || se || w)
                && (e || me || n || ne || nw || sw || w)
                && (e || me || n || ne || s || se || sw)
                && (e || me || n || ne || s || se || w)
                && (e || me || n || ne || s || sw || w)
                && (e || me || n || ne || se || sw || w)
                && (e || me || n || nw || s || se || sw)
                && (e || me || n || nw || s || se || w)
                && (e || me || n || nw || s || sw || w)
                && (e || me || n || nw || se || sw || w)
                && (e || me || n || s || se || sw || w)
                && (e || me || ne || nw || s || se || sw)
                && (e || me || ne || nw || s || se || w)
                && (e || me || ne || nw || s || sw || w)
                && (e || me || ne || nw || se || sw || w)
                && (e || me || ne || s || se || sw || w)
                && (e || me || nw || s || se || sw || w)
                && (e || n || ne || nw || s || se || sw)
                && (e || n || ne || nw || s || se || w)
                && (e || n || ne || nw || s || sw || w)
                && (e || n || ne || nw || se || sw || w)
                && (e || n || ne || s || se || sw || w)
                && (e || n || nw || s || se || sw || w)
                && (e || ne || nw || s || se || sw || w)
                && (me || n || ne || nw || s || se || sw)
                && (me || n || ne || nw || s || se || w)
                && (me || n || ne || nw || s || sw || w)
                && (me || n || ne || nw || se || sw || w)
                && (me || n || ne || s || se || sw || w)
                && (me || n || nw || s || se || sw || w)
                && (me || ne || nw || s || se || sw || w)
                && (n || ne || nw || s || se || sw || w)
                && ((!e) || (!n) || (!ne) || (!nw))
                && ((!e) || (!n) || (!ne) || (!s))
                && ((!e) || (!n) || (!ne) || (!se))
                && ((!e) || (!n) || (!ne) || (!sw))
                && ((!e) || (!n) || (!ne) || (!w))
                && ((!e) || (!n) || (!nw) || (!s))
                && ((!e) || (!n) || (!nw) || (!se))
                && ((!e) || (!n) || (!nw) || (!sw))
                && ((!e) || (!n) || (!nw) || (!w))
                && ((!e) || (!n) || (!s) || (!se))
                && ((!e) || (!n) || (!s) || (!sw))
                && ((!e) || (!n) || (!s) || (!w))
                && ((!e) || (!n) || (!se) || (!sw))
                && ((!e) || (!n) || (!se) || (!w))
                && ((!e) || (!n) || (!sw) || (!w))
                && ((!e) || (!ne) || (!nw) || (!s))
                && ((!e) || (!ne) || (!nw) || (!se))
                && ((!e) || (!ne) || (!nw) || (!sw))
                && ((!e) || (!ne) || (!nw) || (!w))
                && ((!e) || (!ne) || (!s) || (!se))
                && ((!e) || (!ne) || (!s) || (!sw))
                && ((!e) || (!ne) || (!s) || (!w))
                && ((!e) || (!ne) || (!se) || (!sw))
                && ((!e) || (!ne) || (!se) || (!w))
                && ((!e) || (!ne) || (!sw) || (!w))
                && ((!e) || (!nw) || (!s) || (!se))
                && ((!e) || (!nw) || (!s) || (!sw))
                && ((!e) || (!nw) || (!s) || (!w))
                && ((!e) || (!nw) || (!se) || (!sw))
                && ((!e) || (!nw) || (!se) || (!w))
                && ((!e) || (!nw) || (!sw) || (!w))
                && ((!e) || (!s) || (!se) || (!sw))
                && ((!e) || (!s) || (!se) || (!w))
                && ((!e) || (!s) || (!sw) || (!w))
                && ((!e) || (!se) || (!sw) || (!w))
                && ((!n) || (!ne) || (!nw) || (!s))
                && ((!n) || (!ne) || (!nw) || (!se))
                && ((!n) || (!ne) || (!nw) || (!sw))
                && ((!n) || (!ne) || (!nw) || (!w))
                && ((!n) || (!ne) || (!s) || (!se))
                && ((!n) || (!ne) || (!s) || (!sw))
                && ((!n) || (!ne) || (!s) || (!w))
                && ((!n) || (!ne) || (!se) || (!sw))
                && ((!n) || (!ne) || (!se) || (!w))
                && ((!n) || (!ne) || (!sw) || (!w))
                && ((!n) || (!nw) || (!s) || (!se))
                && ((!n) || (!nw) || (!s) || (!sw))
                && ((!n) || (!nw) || (!s) || (!w))
                && ((!n) || (!nw) || (!se) || (!sw))
                && ((!n) || (!nw) || (!se) || (!w))
                && ((!n) || (!nw) || (!sw) || (!w))
                && ((!n) || (!s) || (!se) || (!sw))
                && ((!n) || (!s) || (!se) || (!w))
                && ((!n) || (!s) || (!sw) || (!w))
                && ((!n) || (!se) || (!sw) || (!w))
                && ((!ne) || (!nw) || (!s) || (!se))
                && ((!ne) || (!nw) || (!s) || (!sw))
                && ((!ne) || (!nw) || (!s) || (!w))
                && ((!ne) || (!nw) || (!se) || (!sw))
                && ((!ne) || (!nw) || (!se) || (!w))
                && ((!ne) || (!nw) || (!sw) || (!w))
                && ((!ne) || (!s) || (!se) || (!sw))
                && ((!ne) || (!s) || (!se) || (!w))
                && ((!ne) || (!s) || (!sw) || (!w))
                && ((!ne) || (!se) || (!sw) || (!w))
                && ((!nw) || (!s) || (!se) || (!sw))
                && ((!nw) || (!s) || (!se) || (!w))
                && ((!nw) || (!s) || (!sw) || (!w))
                && ((!nw) || (!se) || (!sw) || (!w))
                && ((!s) || (!se) || (!sw) || (!w));
/* svlint off style_operator_boolean_leading_space */

endmodule

`default_nettype wire
