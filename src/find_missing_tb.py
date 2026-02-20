#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
"""Find Verilog files that do not have a matching testbench."""

from pathlib import Path

base_dir = Path(__file__).parent
test_dir = base_dir / "tests"

for file in base_dir.glob("*.sv"):
    test_file = test_dir / f"{file.stem}_tb.sv"
    if not test_file.exists():
        print(file.stem)
