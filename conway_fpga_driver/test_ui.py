#!/usr/bin/env python3
# -*- coding: UTF-8 -*-
"""UI for controlling the MCU that drives the FPGA."""

import tkinter as tk
from tkinter import ttk
import serial
import serial.tools.list_ports
from sympy import cycle_length


class GUI(tk.Tk):
    """Main user interface."""

    def __init__(self) -> None:
        """Initialize the UI."""
        super().__init__()
        self.initial_var = tk.StringVar(self, value="0x0000001c00000000")
        self.sleep_var = tk.StringVar(self, value="25")
        self.result_var = tk.StringVar(self, value="")
        self.cycles_var = tk.StringVar(self, value="0")

        self.port_select = ttk.Combobox(self, state="readonly")
        self.refresh_ports = ttk.Button(
            self, text="Refresh", command=self.update_ports
        )
        self.initial_entry = ttk.Entry(self, textvariable=self.initial_var)
        self.sleep_time = ttk.Entry(self, textvariable=self.sleep_var)
        self.cycles_entry = ttk.Entry(self, textvariable=self.cycles_var)
        self.result_display = ttk.Entry(
            self, state="readonly", textvariable=self.result_var
        )
        self.run_button = ttk.Button(self, text="Run", command=self.run)

        ttk.Label(self, text="Port:").grid(row=0, column=0)
        self.port_select.grid(row=0, column=1, sticky=tk.EW)
        self.refresh_ports.grid(row=0, column=2)

        ttk.Label(self, text="Initial:").grid(row=1, column=0)
        self.initial_entry.grid(row=1, column=1, columnspan=2, sticky=tk.EW)

        ttk.Label(self, text="Sleep Time (ms):").grid(row=2, column=0)
        self.sleep_time.grid(row=2, column=1, columnspan=2, sticky=tk.EW)

        ttk.Label(self, text="Run Cycles:").grid(row=3, column=0)
        self.cycles_entry.grid(row=3, column=1, columnspan=2, sticky=tk.EW)

        ttk.Label(self, text="Result:").grid(row=4, column=0)
        self.result_display.grid(row=4, column=1, columnspan=2, sticky=tk.EW)

        self.run_button.grid(row=5, columnspan=3, sticky=tk.EW)

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

        init_str = self.initial_var.get()
        if init_str.startswith("0x"):
            initial = int(init_str, 16)
        elif init_str.startswith("0b"):
            initial = int(init_str, 2)
        elif init_str.startswith("0o"):
            initial = int(init_str, 8)
        else:
            initial = int(init_str)
        with serial.Serial(self.port_select.get(), baudrate=115200) as ser:
            ser.read_until(b"READY\n")
            ser.write(
                sleep_time.to_bytes(4, "little", signed=False)
                + initial.to_bytes(8, "little", signed=False)
                + num_cycles.to_bytes(4, "little", signed=False)
            )
            result = int.from_bytes(ser.read(8), "little", signed=False)
            # print(ser.read_until(b"\n"))
        self.result_var.set(f"0x{result:016X}")


if __name__ == "__main__":
    GUI().mainloop()
