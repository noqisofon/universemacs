# -*- coding: utf-8; -*-

el_files := $(wildcard ../../core/*.el)

all: tangle
.PHONY: all

tangle: $(el_files)
.PHONY: tangle

../../core/core-auto-completion.el: ./core-auto-completion.org
../../core/core-command-line: ./core-command-line.org
../../core/core-configuration-layer.el: ./core-configuration-layer.org
../../core/core-debug.el: ./core-debug.org
../../core/core-display-init.el: ./core-display-init.org
../../core/core-dotuniversemacs.el: ./core-dotuniversemacs.org
../../core/core-fonts-support.el: ./core-fonts-support.org
../../core/core-funcs.el: ./core-funcs.org
../../core/core-jump.el: ./core-jump.org
../../core/core-keybindings.el: ./core-keybindings.org
../../core/core-load-paths.el: ./core-load-paths.org
../../core/core-micro-state.el: ./core-micro-state.org
../../core/core-release-management.el: ./core-release-management.org
../../core/core-themes-support.el: ./core-themes-support.org
../../core/core-toggle.el: ./core-toggle.org
../../core/core-transient-state.el: ./core-transient-state.org
../../core/core-universemacs.el: ./core-universemacs.org
../../core/core-universemacs-buffer.el: ./core-universemacs-buffer.org
../../core/core-use-package-ext.el: ./core-use-package-ext.org

../../core/%.el: ./%.org
	../../tools/org-babel-tangle $<
