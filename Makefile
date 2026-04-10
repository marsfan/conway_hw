
TTOOL=./tt/tt_tool.py
PROCESS=--ihp

TTOOL_CMD = $(TTOOL) $(PROCESS)

.PHONY:  config configure harden stats openroad test warnings clean distclean fpga

configure config:
	$(TTOOL_CMD) --create-user-config

# FIXME: Figure out how to have `configure` called if src/config.json or info.yaml was modified
harden:
	$(TTOOL_CMD) --harden

stats:
	$(TTOOL_CMD) --print-stats --print-cell-summary --print-cell-category

openroad:
	$(TTOOL_CMD) --open-in-openroad

test:
	$(MAKE) -C src test

warnings:
	$(TTOOL_CMD) --print-warnings

clean:
	$(MAKE) -C src clean
	rm -rf runs

distclean: clean
	rm -f src/config_merged.json
	rm -f src/user_config.json

fpga:
	tt/tt_fpga.py harden