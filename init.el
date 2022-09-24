(eval-when-compile
  (unless (require 'use-package nil t)
    ;; use-package が存在しない場合、何もしない use-package を定義しておきます。
    (defmacro use-package (&rest args))))

;; カスタム内容が書き込まれるファイルを custom.el にしておきます。
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
;; custom.el が存在した場合にそれをロードします。
(when (file-exists-p custom-file)
  (load custom-file))

(package-initialize)
(customize-set-variable 'package-archives
                        `(,@package-archives
                          ("melpa" . "https://melpa.org/packages/")))

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
  :if (eq system-type 'gnu/linux)
  :bind ("[hankaku-zenkaku]" . toggle-input-method)
  :init
  (setq default-input-method "japanese-mozc"))

;; その他のメジャーモード
(use-package cc-mode
  :config
  (setq tab-width 4)
  (setq c-basic-offset tab-width)
  (setq indent-tabs-mode nil))

(use-package raku-mode
  :mode (("\\.raku\\'"     . raku-mode)
		 ("\\.rakumod\\'"  . raku-mode)
		 ("\\.rakutest\\'" . raku-mode)
		 ("\\.pl6\\'"      . raku-mode)
		 ("\\.p6\\'"       . raku-mode))
  :config
  ;; raku-mode の設定
  )

(use-package markdown-mode
  :mode (("\\.md\\'" . markdown-mode))
  :config
  ;; markdown-mode の設定
  )

(use-package python-mode
  :mode (("\\.py\\'" . python-mode))
  :interpreter ("python" . python-mode))

(use-package ruby-mode
  :interpreter (("ruby"    . ruby-mode)
			    ("rbx"     . ruby-mode)
			    ("jruby"   . ruby-mode)
			    ("ruby1.9" . ruby-mode)
			    ("ruby1.8" . ruby-mode))
  :config
  ;; ruby-mode の設定
  )

(use-package web-mode
  :mode (("\\.html?\\'"  . web-mode)
		 ("\\.jsp\\'"    . web-mode)
		 ("\\.gsp\\'"    . web-mode)
		 ("\\.cshtml\\'" . web-mode))
  :config
  ;; web-mode の設定
  )

