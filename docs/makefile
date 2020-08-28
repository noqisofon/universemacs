# -*- coding: utf-8; -*-

.PHONY: all
all: tangle change-dir

.PHONY: tangle
tangle: ./init.org
	../tools/org-babel-tangle ./init.org

.PHONY: change-dir
change-dir:
	make -C ./core
