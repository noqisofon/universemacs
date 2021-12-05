# -*- coding: utf-8; -*-

org_files := $(wildcard ./*.org)

el_files  := $(addsuffix .el, $(addprefix ../../core/, $(basename $(notdir $(org_files)))))

all: tangle
.PHONY: all

tangle: $(el_files)
.PHONY: tangle

../../core/%.el: ./%.org
	../../tools/org-babel-tangle $<
