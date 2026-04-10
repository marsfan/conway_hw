#!/usr/bin/env python3
# -*- coding: UTF-8 -*-
"""UI for direct control over the IO pins to/from the FPGA."""

import tkinter as tk
from tkinter import ttk
import serial
import serial.tools.list_ports

BAUD = 115200


class GUI(tk.Tk):
    """Main user interface."""

    def __init__(self) -> None:
        """Initialize the UI."""
        super().__init__()
        self.sleep_var = tk.StringVar(self, value="25")
        self.reset_var = tk.BooleanVar(self, value=True)
        self.data_in_var = tk.BooleanVar(self, value=False)
        self.data_out_var = tk.BooleanVar(self, value=False)
        self.mode_var = tk.StringVar(self, value="0b00")
        self.port_var = tk.StringVar(self, value="")

        self.port_select = ttk.Combobox(
            self,
            state="readonly",
            textvariable=self.port_var,
        )
        self.refresh_ports = ttk.Button(
            self,
            text="Refresh",
            command=self.update_ports,
        )
        self.connect_button = ttk.Button(
            self,
            text="Connect",
            command=self.connect_disconnect,
        )
        self.mode_entry = ttk.Combobox(
            self,
            values=["00", "01", "10", "11"],
            textvariable=self.mode_var,
            state="readonly",
        )
        self.sleep_time = ttk.Entry(self, textvariable=self.sleep_var)
        self.reset = ttk.Checkbutton(self, variable=self.reset_var)
        self.data_in = ttk.Checkbutton(self, variable=self.data_in_var)
        self.data_out = ttk.Checkbutton(self, variable=self.data_out_var)

        self.cycle_clock_btn = ttk.Button(
            self,
            text="Cycle Clock",
            command=self.cycle_clock,
        )

        ttk.Label(self, text="Port:").grid(row=0, column=0)
        self.port_select.grid(row=0, column=1, sticky=tk.EW)
        self.refresh_ports.grid(row=0, column=2)

        ttk.Label(self, text="Mode Bits").grid(row=1, column=0)
        self.mode_entry.grid(row=1, column=1, sticky=tk.EW)
        self.connect_button.grid(row=1, column=2, sticky=tk.EW)

        ttk.Label(self, text="Sleep Time (ms):").grid(row=2, column=0)
        self.sleep_time.grid(row=2, column=1, columnspan=2, sticky=tk.EW)

        ttk.Label(self, text="Reset:").grid(row=3, column=0)
        self.reset.grid(row=3, column=1, columnspan=2, sticky=tk.EW)

        ttk.Label(self, text="Data In:").grid(row=4, column=0)
        self.data_in.grid(row=4, column=1, columnspan=2, sticky=tk.EW)

        ttk.Label(self, text="Data Out:").grid(row=5, column=0)
        self.data_out.grid(row=5, column=1, columnspan=2, sticky=tk.EW)

        self.cycle_clock_btn.grid(row=6, columnspan=3, sticky=tk.EW)

        self.update_ports()
        self.mode_entry.set("00")
        self.mode_var.trace_add("write", self.set_mode)
        self.data_in_var.trace_add("write", self.set_data_in)
        self.reset_var.trace_add("write", self.set_reset)
        self.port_var.trace_add("write", self.port_changed)

        self.ser = serial.Serial(self.port_select.get(), baudrate=BAUD)

        self.mode_entry.config(state="disabled")
        self.reset.config(state="disabled")
        self.data_in.config(state="disabled")
        self.data_out.config(state="disabled")
        self.sleep_time.config(state="disabled")
        self.cycle_clock_btn.config(state="disabled")

    def update_ports(self) -> None:
        """Update list of available COM ports."""
        ports = [p.name for p in serial.tools.list_ports.comports()]
        self.port_select.configure(values=ports)
        if self.port_select.get() not in ports:
            self.port_select.set(ports[0])

    def port_changed(self, _varname: str, _index: str, _action: str) -> None:
        """Handle the selected port being changed."""
        if self.ser.is_open:
            self.connect_disconnect()
        self.ser = serial.Serial(self.port_select.get(), baudrate=BAUD)

    def cycle_clock(self) -> None:
        """Run the clock for a single cycle."""
        self._send_command(b"c", int(self.sleep_var.get()))

    def set_mode(self, _varname: str, _index: str, _action: str) -> None:
        """Set the mode bits states."""
        self._send_command(b"m", int(self.mode_var.get(), 2))

    def set_reset(self, _varname: str, _index: str, _action: str) -> None:
        """Set the reset bit state."""
        self._send_command(b"r", int(self.reset_var.get()))

    def set_data_in(self, _varname: str, _index: str, _action: str) -> None:
        """Set the data in bit state."""
        self._send_command(b"i", int(self.data_in_var.get()))

    def _send_command(self, command: bytes, value: int) -> None:
        """Send a command to the Arduino.

        Arguments:
            command: The single-byte command to send
            value: Extra value to send alongside the command.

        Raises:
            ValueError: Raised if the command is not 1 byte

        """
        if len(command) != 1:
            raise ValueError("Command must be a single byte.")
        # self.ser.read_until(b"READY\n")
        self.ser.write(
            b"c" + command + value.to_bytes(4, "little", signed=False)
        )
        result = int.from_bytes(self.ser.read(1), "little", signed=False)
        self.data_out_var.set(result != 0)

    def connect_disconnect(self) -> None:
        """Connect or disconnect from the"""
        if not self.ser.is_open:
            self.connect_button.config(text="Disconnect")
            self.ser.open()
            self.mode_entry.config(state="readonly")
            self.reset.config(state="normal")
            self.data_in.config(state="normal")
            self.data_out.config(state="readonly")
            self.sleep_time.config(state="normal")
            self.cycle_clock_btn.config(state="normal")
        else:
            self.connect_button.config(text="Connect")
            self.ser.close()
            self.mode_entry.config(state="disabled")
            self.reset.config(state="disabled")
            self.data_in.config(state="disabled")
            self.data_out.config(state="disabled")
            self.sleep_time.config(state="disabled")
            self.cycle_clock_btn.config(state="disabled")


if __name__ == "__main__":
    GUI().mainloop()
