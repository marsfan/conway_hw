#!/usr/bin/env python3
# -*- coding: UTF-8 -*-
"""Create truthtable for for a single cell in Conway's game of life.

For each "cell" in Conway's game of life, there is a total of 9 inputs.
* The cell's current state
* The state of all surrounding cells.

The cells are named by their compass rose orientation relative to the cell
itself (which is called "me")

"""

from itertools import product


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
        return True
    else:
        # All other cases are dead and should stay dead
        return False


def main() -> None:
    """Calculate all possible states, ane export to a CSV file for Logisim."""
    results: list[tuple[list[bool], bool]] = []

    # Calculate output for all possible inputs
    for states in product(*([[False, True]] * 9)):
        result = calc_result(*states)
        results.append((list(states), result))

    # Write results to CSV
    with open("single_cell_tt.csv", "w", encoding="UTF-8") as file:
        # Header
        file.write("ME,N,NE,E,SE,S,SW,W,NW,|,O\n")
        # states
        for inputs, output in results:
            for inp in inputs:
                file.write(f"{int(inp)},")
            file.write("|,")
            file.write(f"{int(output)}\n")


if __name__ == "__main__":
    main()
