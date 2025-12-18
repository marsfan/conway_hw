#!/usr/bin/env python3
# -*- coding: UTF-8 -*-
"""Find VHDL Files that do not have a matching testbench."""
from pathlib import Path

base_dir = Path(__file__).parent
test_dir = base_dir / "tests"

for file in base_dir.glob("*.vhd"):
    test_file = test_dir / f"{file.stem}_tb.vhd"
    if not test_file.exists():
        print(file.stem)
