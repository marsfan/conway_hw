#!/usr/bin/env python3
# -*- coding: UTF-8 -*-
"""UI for controlling the MCU that drives the FPGA."""

import tkinter as tk
from tkinter import ttk
import serial
import serial.tools.list_ports

NUM_ROWS = 8
NUM_COLS = 8
NUM_CELLS = NUM_ROWS * NUM_COLS


class ConwayGrid(ttk.Frame):
    """Grid of checkboxes for conway's game of life."""

    def __init__(self, master: tk.Misc, rows: int, cols: int) -> None:
        """Initialize the widget.

        Arguments:
            master: Widget to parent to this one
            rows: Number of rows in the grid.
            cols: Number of columns in the grid.

        """
        super().__init__(master)
        self.cb_vars: list[tk.BooleanVar] = []
        x = 1
        y = 1
        for x in range(rows):
            for y in range(cols):
                var = tk.BooleanVar(self, False)
                button = ttk.Checkbutton(self, variable=var)
                var.trace_add("write", self._on_checkbox_change)
                self.cb_vars.append(var)
                button.grid(row=x, column=y)

        self.readout_text = tk.StringVar(self, value="")
        self.readout = ttk.Label(self, textvariable=self.readout_text)
        self.readout.grid(row=x + 1, column=0, columnspan=y)

        self._on_checkbox_change("", "", "write")

    def _on_checkbox_change(
        self,
        _varname: str,
        _index: str,
        _operation: str,
    ) -> None:
        """Update readout text when checkbuttons modified.

        Arguments:
            _varname: Name of the variable
            _index: Index into variable if it is an array var.
            _operation: The type of operation performed on the variable

        """
        result = 0
        for i, var in enumerate(self.cb_vars):
            result |= var.get() << i

        self.readout_text.set(f"0x{result:016X}")


class GUI(tk.Tk):
    """Main user interface."""

    def __init__(self) -> None:
        """Initialize the UI."""
        super().__init__()
        # self.initial_var = tk.StringVar(self, value="0x0000001c00000000")
        self.sleep_var = tk.StringVar(self, value="25")
        self.cycles_var = tk.StringVar(self, value="0")

        self.port_select = ttk.Combobox(self, state="readonly")
        self.refresh_ports = ttk.Button(
            self, text="Refresh", command=self.update_ports
        )
        self.initial_entry = ConwayGrid(self, NUM_ROWS, NUM_COLS)
        self.sleep_time = ttk.Entry(self, textvariable=self.sleep_var)
        self.cycles_entry = ttk.Entry(self, textvariable=self.cycles_var)
        self.result_display = ConwayGrid(self, NUM_ROWS, NUM_COLS)

        self.run_button = ttk.Button(self, text="Run", command=self.run)

        ttk.Label(self, text="Port:").grid(row=0, column=0)
        self.port_select.grid(row=0, column=1, sticky=tk.EW)
        self.refresh_ports.grid(row=0, column=2)

        ttk.Label(self, text="Sleep Time (ms):").grid(row=1, column=0)
        self.sleep_time.grid(row=1, column=1, columnspan=2, sticky=tk.EW)

        ttk.Label(self, text="Run Cycles:").grid(row=2, column=0)
        self.cycles_entry.grid(row=2, column=1, columnspan=2, sticky=tk.EW)

        ttk.Label(self, text="Initial:").grid(row=3, column=0)
        self.initial_entry.grid(row=3, column=1, columnspan=2, sticky=tk.EW)

        ttk.Separator(self).grid(row=4, column=0, columnspan=3, sticky=tk.EW)

        ttk.Label(self, text="Result:").grid(row=5, column=0)
        self.result_display.grid(row=5, column=1, columnspan=2, sticky=tk.EW)

        self.run_button.grid(row=6, columnspan=3, sticky=tk.EW)

        self.update_ports()

    def update_ports(self) -> None:
        """Update list of available COM ports."""
        ports = [p.name for p in serial.tools.list_ports.comports()]
        self.port_select.configure(values=ports)
        if self.port_select.get() not in ports:
            self.port_select.set(ports[0])

    def run(self) -> None:
        """Run test and display result."""
        sleep_time = int(self.sleep_var.get())
        num_cycles = int(self.cycles_var.get())

        initial = 0
        for i, var in enumerate(self.initial_entry.cb_vars):
            initial |= int(var.get()) << i

        with serial.Serial(self.port_select.get(), baudrate=115200) as ser:
            ser.read_until(b"READY\n")
            ser.write(
                b"t"
                + sleep_time.to_bytes(4, "little", signed=False)
                + initial.to_bytes(8, "little", signed=False)
                + num_cycles.to_bytes(4, "little", signed=False)
            )
            result = int.from_bytes(ser.read(8), "little", signed=False)
            # print(ser.read_until(b"\n"))
            print(result)
        for i, var in enumerate(self.result_display.cb_vars):
            bit = (result >> i) & 0b1
            var.set(bool(bit))


if __name__ == "__main__":
    GUI().mainloop()
