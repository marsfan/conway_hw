import subprocess
from pathlib import Path

files = list(Path().glob("*.sv"))
files = list(Path().glob("*.svh"))
files = list(Path().glob("tests/*.svh"))
files = list(Path().glob("tests/*.sv"))
subprocess.run(
    ["../verible-v0.0-4051-g9fdb4057-win64/verible-verilog-lint.exe", *files]
)
