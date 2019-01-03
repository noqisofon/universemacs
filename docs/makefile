# -*- coding: utf-8; -*-

.PHONY: all
all: tangle change-dir

.PHONY: tangle
tangle: ./init.org
	org-babel-tangle ./init.org

.PHONY: change-dir
change-dir:
	make -C ./core
