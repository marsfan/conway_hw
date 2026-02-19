import subprocess
from pathlib import Path
import sys

files = list(Path().glob("*.sv"))
files.extend(Path().glob("*.svh"))
files.extend(Path().glob("tests/*.svh"))
files.extend(Path().glob("tests/*.sv"))
result = subprocess.run(
    [
        "../verible-v0.0-4051-g9fdb4057-win64/verible-verilog-lint.exe",
        "--rules_config",
        ".rules.verible_lint",
        *files,
    ],
    check=False,
)
sys.exit(result.returncode)
