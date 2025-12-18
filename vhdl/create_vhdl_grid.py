#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https: //mozilla.org/MPL/2.0/.
"""Create VHDL file with the grid of cell calculators."""

from pathlib import Path

vhdl_file = Path("vhdl/cell_grid.vhd")

MAX_W = 8
MAX_H = 8


def calc_index(w: int, h: int) -> int:
    return w * MAX_H + h


def create_interface(w: int, h: int) -> str:
    if w < 0:
        return "'0'"
    if h < 0:
        return "'0'"
    if w >= MAX_W:
        return "'0'"
    if h >= MAX_H:
        return "'0'"
    return f"INPUT_STATE({calc_index(w, h)})"


def main() -> None:
    contents = Path("vhdl/cell_grid.vhd").read_text("UTF-8")

    before_grid, grid_and_after = contents.split(
        "-- NOTE: Start of cell grid here"
    )
    _, after_grid = grid_and_after.split("-- NOTE: End of cell grid here.")

    grid = ""
    for w in range(MAX_W):
        for h in range(MAX_H):
            name = f"cell_{w}_{h}"

            instance = f"""\
    {name} : SINGLE_CELL port map(
        ME => {create_interface(w, h)},
        N => {create_interface(w, h - 1)},
        NE => {create_interface(w + 1, h - 1)},
        E => {create_interface(w + 1, h)},
        SE => {create_interface(w + 1, h + 1)},
        S => {create_interface(w, h + 1)},
        SW => {create_interface(w - 1, h + 1)},
        W => {create_interface(w - 1, h)},
        NW => {create_interface(w - 1, h - 1)},
        IS_ALIVE => NEXT_STATE({calc_index(w, h)})
    );\n
"""
            grid += instance

    contents = (
        before_grid
        + "-- NOTE: Start of cell grid here\n"
        + grid
        + "\n-- NOTE: End of cell grid here."
        + after_grid
    )
    vhdl_file.write_text(contents, encoding="utf-8")


if __name__ == "__main__":
    main()
