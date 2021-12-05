# -*- coding: utf-8; -*-

all: tangle change-dir
.PHONY: all

tangle: ../init.el
.PHONY: tangle

change-dir:
	make -C ./core
.PHONY: change-dir

../%.el: ./%.org
	../tools/org-babel-tangle $<
