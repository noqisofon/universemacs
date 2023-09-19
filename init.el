;; -*- mode: emacs-lisp; -*-
(defmacro when-require (feature &rest body)
  `(when (require (quote ,feature) nil t)
     ,@body))

(eval-when-compile
  (unless (require 'use-package nil t)
    ;; use-package が存在しない場合、何もしない use-package を定義しておきます。
    (defmacro use-package (&rest args))))

(cd "~/")

;; カスタム内容が書き込まれるファイルを custom.el にしておきます。
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
;; custom.el が存在した場合にそれをロードします。
(when (file-exists-p custom-file)
  (load custom-file))

(package-initialize)
(customize-set-variable 'package-archives
                        `(,@package-archives
                          ("melpa" . "https://melpa.org/packages/")))

;; さーばーファイルの名前を server-<emacs の PID> とする。
(setq server-name (file-name-with-extension (make-temp-name "server-") ".socket"))
;; server は emacs にバンドルされているもののため、when-require にする。
(when-require server
              (let ((got (server-running-p)))
                (cond ((eq got :other)
                       ;; :other が返ってくることもあるため、その場合は server-start を行う。
                       (server-start))
                      ((not got)
                       ;; さーばー担当の Emacs が動いてなかったらさーばーを始める。
                       (server-start)))))

(use-package emacs
  :init
  (setq-default
   ;; インデントをタブで行わない。
   indent-tabs-mode nil
   ;; タブ文字の長さは(半角スペース) 4 つ分。
   tab-width 4)
  :config
  ;; ツールバーを消去する。
  (tool-bar-mode -1)
  ;; 対になるカッコをハイライトする。
  (show-paren-mode t)
  ;; モードライン？にカラム数も表示する。
  (column-number-mode t)
  ;; セレクションに上書きします。
  (delete-selection-mode t)
  ;; オートリバートモードを有効にします。
  (global-auto-revert-mode)

  ;; emacs 26 でついに行数表示のネイティブ実装であるところの  global-display-line-numbers-mode が追加された。
  (when (version<= "26.0.50" emacs-version)
    (global-display-line-numbers-mode))

  ;; フォント
  (set-face-attribute 'default nil
                      :family "FirgeNerd"
                      :height (* 10 10))

  ;; テーマ
  (load-theme 'dichromacy t)
         
  ;; 日本語の文字コードを設定します。
  (set-language-environment "Japanese")
  (prefer-coding-system 'utf-8)

  (when (eq system-type 'windows-nt)
    (set-file-name-coding-system 'cp932)
    (set-keyboard-coding-system 'cp932)
    (set-terminal-coding-system 'cp932))

  (set-charset-priority 'ascii
                        'japanese-jisx0208
                        'katakana-jisx0201
                        'iso-8859-1
                        'cp1252
                        'unicode)

  (set-coding-system-priority 'utf-8
                              'euc-jp
                              'iso-2022-jp
                              'cp932))

;; IME の設定
(use-package tr-ime
  :if (eq system-type 'windows-nt)
  :init
  ;; 入力方法を IME に設定します。
  (setq default-input-method "W32-IME")
  ;; IME のモードラインの表示設定です。
  (setq-default w32-ime-mode-line-state-indicator "[--]")
  (setq w32-ime-mode-line-state-indicator-line '("[--]" "[あ]" "[--]"))
  :config
  (tr-ime-standard-install)
  (w32-ime-initialize))

(use-package mozc
  :ensure t
  :if (eq system-type 'gnu/linux)
  ;;:bind ("[zenkaku-hankaku]" . toggle-input-method)
  :config
  (setq default-input-method "japanese-mozc")
  ;; :bind だと、なぜか動かないので、:init に書いた。
  (global-set-key (kbd "<zenkaku-hankaku>") 'toggle-input-method)
  )

(use-package mozc-popup
  :ensure t
  :defer t
  :if (featurep 'mozc)
  :init
  (setq mozc-candidate-style 'echo-area))

;; その他のメジャーモード
(use-package cc-mode
  :defer t
  :config
  (setq tab-width 4)
  (setq c-basic-offset tab-width)
  (setq indent-tabs-mode nil))

(use-package raku-mode
  :ensure t
  :defer t
  :mode (("\\.raku\\'"     . raku-mode)
         ("\\.rakumod\\'"  . raku-mode)
         ("\\.rakutest\\'" . raku-mode)
         ("\\.pl6\\'"      . raku-mode)
         ("\\.p6\\'"       . raku-mode))
  :config
  ;; .rakumod や .raku を作成すると、スケルトンを挿入します。
  (define-auto-insert '("\\.rakumod\\'" . "Raku module skelton") 'raku-module-skelton)
  (define-auto-insert '("\\.raku\\'"    . "Raku module skelton") 'raku-script-skelton)
  )

(use-package markdown-mode
  :ensure t
  :defer t
  :mode (("\\.md\\'" . markdown-mode))
  :config
  ;; markdown-mode の設定
  )

(use-package python-mode
  :defer t
  :mode (("\\.py\\'" . python-mode))
  :interpreter ("python" . python-mode)
  :init
  (setq python-indent-offset tab-width))

(use-package ruby-mode
  :defer t
  :interpreter (("ruby"    . ruby-mode)
                ("rbx"     . ruby-mode)
                ("jruby"   . ruby-mode)
                ("ruby1.9" . ruby-mode)
                ("ruby1.8" . ruby-mode))
  :config
  ;; ruby-mode の設定
  )

(use-package web-mode
  :ensure t
  :defer t
  :mode (("\\.jsp\\'"    . web-mode)
         ("\\.gsp\\'"    . web-mode)
         ("\\.cshtml\\'" . web-mode)
         ("\\.razor\\'"  . web-mode))
  :config
  ;; web-mode の設定
  (setq web-mode-attr-indent-offset nil)

  (setq web-mode-enable-auto-closing t)
  (setq web-mode-enable-auto-pairing t)

  (setq web-mode-auto-close-style 2)
  (setq web-mode-tag-auto-close-style 2)

  (setq web-mode-markup-indent-offset 4)
  (setq web-mode-css-indent-offset 4)
  (setq web-mode-code-indent-offset 4)

  (setq indent-tabs-mode nil)

  (setq web-mode-engines-alist
        '(("php"   . "\\.phtml\\'")
          ("blade" . "\\.blade\\'"))))

(use-package js2-mode
  :ensure t
  :defer t
  :mode (("\\.js\\'" . js2-mode))
  :init
  (setq js-indent-level 4))

(use-package typescript-mode
  :ensure t
  :defer t
  :mode (("\\.ts\\'"  . typescript-mode))
  :init
  (setq typescript-indent-level 4))

(use-package rjsx-mode
  :ensure t
  :defer t
  :mode (("\\.jsx\\'" . rjsx-mode)
         ("\\.tsx\\'" . rjsx-mode))
  )

(use-package tree-sitter
  :ensure t
  :defer t)

(use-package tree-sitter-langs
  :ensure t
  :defer t)

(use-package tree-sitter-indent
  :ensure t
  :defer t)

(use-package csharp-mode
  :ensure t
  :defer t
  :requires (tree-sitter tree-sitter-langs tree-sitter-indent)
  :mode (("\\.cs\\'" . csharp-mode))
  :config
  (add-to-list 'auto-mode-alist '("\\.cs\\'" . csharp-tree-sitter-mode)))

(use-package scheme-mode
  :defer t
  :requires (geiser-guile quack)
  :mode ("\\.scm\\'" . scheme-mode)
  :init
  (setq scheme-program-name "gambit")
  :config
  (defun scheme-mode-quack-hook ()
    ; (require 'quack)
    (setq quack-fontify-style 'emacs))
  (add-hook 'scheme-mode-hook 'scheme-mode-quack-hook)
  )

(use-package geiser-guile
  :ensure t
  :defer t
  :init
  (setq geiser-active-implementations '(guile gauche gambit))
  (setq geiser-scheme-implementation 'guile)
  (setq geiser-guile-binary "guile")
  )

(use-package quack
  :ensure t
  :defer t)

(use-package purescript-mode
  :ensure t
  :defer t
  :config
  (add-hook 'purescript-mode-hook 'turn-on-purescript-indent))

(use-package groovy-mode
  :ensure t
  :defer t
  :mode (("\\.gy\\'"     . groovy-mode)
         ("\\.gsh\\'"    . groovy-mode)
         ("\\.gvy\\'"    . groovy-mode)
         ("\\.groovy\\'" . groovy-mode)
         ("\\.gradle\\'" . groovy-mode)))

(use-package fsharp-mode
  :ensure t
  :defer t
  :mode (("\\.fs\\'"  . fsharp-mode)
         ("\\.fsx\\'" . fsharp-mode)))
