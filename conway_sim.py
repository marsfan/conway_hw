#!/usr/bin/env python3
# -*- coding: UTF-8 -*-
import tkinter as tk
from tkinter import ttk

MAX_X = 8
MAX_Y = 8
SCALE = 50


def check_cell(cells: list[list[bool]], x: int, y: int) -> bool:
    """Check a single cell to see if it should live or die.

    Arguments:
        cells: Current state of all of the cells
        x: X coordinate of the cell to check
        y: Y coordinate of the cell to check

    Returns:
        Whether or not the cell should live or die.

    """
    alive_neighbors = 0
    current_state = cells[x][y]
    n = 0
    for i in [x - 1, x, x + 1]:
        for j in [y - 1, y, y + 1]:
            # Center is this cell, which we don't want to count
            if i == x and j == y:
                continue

            n += 1
            if 0 <= i <= (MAX_X - 1):
                if 0 <= j <= (MAX_Y - 1):
                    alive_neighbors += int(cells[i][j])

    new_state = False
    if current_state and alive_neighbors < 2:
        new_state = False
    elif current_state and alive_neighbors in {2, 3}:
        new_state = True
    elif current_state and alive_neighbors > 3:
        new_state = False
    elif not current_state and alive_neighbors == 3:
        new_state = True

    return new_state


def check_cell_v2(cells: list[list[bool]], x: int, y: int) -> bool:
    """Check a single cell to see if it should live or die.

    Arguments:
        cells: Current state of all of the cells
        x: X coordinate of the cell to check
        y: Y coordinate of the cell to check

    Returns:
        Whether or not the cell should live or die.

    """
    alive_neighbors = 0
    current_state = cells[x][y]
    if x > 0:
        if y > 0:

            alive_neighbors += int(cells[x-1][y-1])  # NW

        alive_neighbors += int(cells[x-1][y])  # N

        if y < (MAX_Y - 1):
            alive_neighbors += int(cells[x-1][y+1])  # NE

    if y > 0:
        alive_neighbors += int(cells[x][y-1])  # W
    if y < (MAX_Y-1):
        alive_neighbors += int(cells[x][y+1])  # E

    if x < (MAX_X-1):
        if y > 0:

            alive_neighbors += int(cells[x+1][y-1])  # SW

        alive_neighbors += int(cells[x+1][y])  # S

        if y < (MAX_Y - 1):
            alive_neighbors += int(cells[x+1][y+1])  # SE

    new_state = False
    if current_state and alive_neighbors < 2:
        new_state = False
    elif current_state and alive_neighbors in {2, 3}:
        new_state = True
    elif current_state and alive_neighbors > 3:
        new_state = False
    elif not current_state and alive_neighbors == 3:
        new_state = True

    return new_state


class GUI(tk.Tk):
    """User interface."""

    def __init__(self) -> None:
        """Initialize UI."""
        super().__init__()
        self.canvas = tk.Canvas(
            self,
            width=640,
            height=480,
        )
        self.cycle_button = tk.Button(
            self,
            command=self.do_cycle,
            text="cycle",
        )
        self.canvas.pack()
        self.cycle_button.pack()
        self.cells = [[False for _ in range(MAX_Y)] for _ in range(MAX_X)]
        self.cells[2][2] = True
        self.cells[2][3] = True
        self.cells[2][4] = True

        self.draw_cells()

    def draw_cells(self) -> None:
        self.canvas.delete("all")
        for i in range(MAX_X):
            for j in range(MAX_Y):
                if self.cells[i][j]:
                    self.canvas.create_rectangle(
                        SCALE * i,
                        SCALE * j,
                        SCALE * i + SCALE,
                        SCALE * j + SCALE,
                        fill="black",
                        outline="white",
                    )
                else:
                    self.canvas.create_rectangle(
                        SCALE * i,
                        SCALE * j,
                        SCALE * i + SCALE,
                        SCALE * j + SCALE,
                    )

    def do_cycle(self) -> None:
        """Do a single cycle."""
        self.cells = [
            [check_cell_v2(self.cells, i, j) for j in range(MAX_Y)] for i in range(MAX_X)
        ]
        self.draw_cells()


if __name__ == "__main__":
    GUI().mainloop()
