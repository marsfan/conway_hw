
TTOOL=./tt/tt_tool.py
PROCESS=--ihp

TTOOL_CMD = $(TTOOL) $(PROCESS)

.PHONY: harden stats openroad test

harden:
	$(TTOOL_CMD) --create-user-config
	$(TTOOL_CMD) --harden

stats:
	$(TTOOL_CMD) --print-stats --print-cell-summary --print-cell-category

openroad:
	$(TTOOL_CMD) --open-in-openroad

test:
	$(MAKE) -C src test