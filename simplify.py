#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https: //mozilla.org/MPL/2.0/.
"""Simplify logic of a single cell in conway's game of life."""

import re
from itertools import product

from sympy import symbols
from sympy.logic.boolalg import POSform, simplify_logic


def calc_result(
    me: bool,
    n: bool,
    ne: bool,
    e: bool,
    se: bool,
    s: bool,
    sw: bool,
    w: bool,
    nw: bool,
) -> bool:
    """Calculate the next state for a cell based on the current state.

    Arguments:
        me: The current state of this cell
        n: State of the cell to the north
        ne:  State of the cell to the north east
        e:  State of the cell to the east
        se:  State of the cell to the southeast
        s:  State of the cell to the south
        sw:  State of the cell to the southwest
        w:  State of the cell to the west
        nw:  State of the cell to northwest.

    Returns:
        New state for the cell.

    """
    # Total number of living neighbors
    num_alive = n + ne + e + se + s + sw + w + nw

    if me and num_alive < 2:
        # Rule 1. If alive and less than 2 neighbors, dies (underpopulation)
        return False
    elif me and num_alive in {2, 3}:
        # Rule 2. If alive and 2 or 3 neighbors, lives
        return True
    elif me and num_alive > 3:
        # Rule 3. If alive and more than 3 neighbors, dies (overpopulation)
        return False
    elif not me and num_alive == 3:
        # Rule 4: If dead and three neighbors, lives (reproduction)
        return False
    else:
        # All other cases are dead and should stay dead
        return False


def main() -> None:
    """Simplify logic of the cell."""
    results: list[tuple[list[bool], bool]] = []
    # Calculate output for all possible inputs
    for states in product(*([[True, False]] * 9)):
        result = calc_result(*states)
        results.append((list(states), result))

    minterms = [v[0] for v in results if v[1]]
    maxterms = [v[0] for v in results if not v[1]]
    print(len(minterms))
    print(len(maxterms))

    me, n, ne, e, se, s, sw, w, nw = symbols("me,n,ne,e,se,s,sw,w,nw")
    product_of_sums = POSform([me, n, ne, e, se, s, sw, w, nw], minterms)
    simplified = simplify_logic(product_of_sums, deep=True, force=True)

    simplified_str = (
        re.sub(r"~(\w+)", r"(NOT \1)", str(simplified))
        .replace("|", "OR")
        .replace("&", "\n    AND")
        .upper()
    )

    print(simplified_str)


if __name__ == "__main__":
    main()
