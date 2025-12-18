#!/usr/bin/env python3
# -*- coding: UTF-8 -*-
"""Fix the single bit breakouts in the diagram."""

from xml.etree.ElementTree import parse, Element

# Dimension of an axis on the diagram.
TO_FIX = 7

root = parse("conway.circ")
circuit = root.find("circuit[@name='main_v2_8']")
assert circuit is not None
for comp in circuit.findall("comp[@name='Splitter']"):
    width = comp.find("a[@name='incoming']")
    assert width is not None
    if width.attrib["val"] == str(TO_FIX - 1):
        width.attrib["val"] = str(8)

        new_bit = Element("a", name=f"bit{6}", val="none")
        comp.append(new_bit)
        new_bit = Element("a", name=f"bit{7}", val="none")
        comp.append(new_bit)

root.write("conway.circ")
