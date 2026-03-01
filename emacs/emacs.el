;; symlink this file to ~/.emacs

;; M-x package-refresh-contents if some package 404s

;; Nicer defaults

(fido-vertical-mode) ; nice completion for M-x
(which-key-mode) ; learn keyboard shortcuts

(setq compilation-scroll-output t)
(setq column-number-mode t)  ; in the mode line

(setq-default show-trailing-whitespace t)
(global-whitespace-mode)
(setopt whitespace-style '(tab-mark))

(xterm-mouse-mode 1)

(save-place-mode t) ; persists your position in files

(setq custom-file "~/.emacs.d/disable-custom-variable-saving") ; do not do weird things when changing variables

(load-theme 'modus-vivendi :no-confirm) ; colorblind-friendly theme... but has issues with emoji and other unicode. If facing issues, M-x disable-theme

;; completion:
;; C-M-i or TAB: accept suggestion if unique/shown, pop up completion list otherwise
;; M-i; complete as much as possible / pop up completion list
(global-completion-preview-mode 1) ; show things that you can tab-complete
(setq tab-always-indent 'complete) ; allow tab to complete
(setq text-mode-ispell-word-completion nil) ; but do not complete dictionary words
(setq completion-auto-select t) ; focus the minibuffer for completion
(setq completions-format 'one-column)

(windmove-default-keybindings) ; S-cursor to move to different windows

(setq org-startup-folded t)

(editorconfig-mode 1)

(add-hook 'js-json-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            (setq js-indent-level 2)))

;; Do not spill temporary files everywhere
;; https://emacs.stackexchange.com/a/81518
(let ((my-auto-save-directory (locate-user-emacs-file "auto-save")))
  (setq auto-save-file-name-transforms
      `((".*" ,my-auto-save-directory t))))

(let ((my-backup-directory (locate-user-emacs-file "backups")))
  (setq backup-directory-alist `("." my-backup-directory)))

(setq create-lockfiles nil)

;; Configure the package manager. Some packages I use are not in the default repositories
(require 'use-package-ensure)
(setq use-package-always-ensure t)
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; I use Wezterm, that supports the Kitty Keyboard Protocol.
;; Using this fixes ¿ and lets Emacs use super, for example.
(use-package kkp
  :ensure t
  :config
  (global-kkp-mode +1))

;; Install xclip so cutting/copying in Emacs on a terminal affects the graphical clipboard
(use-package xclip
  :ensure t
  :config
  (xclip-mode 1))

;; Fancy undo
(use-package undo-tree
  :ensure t
  :config
  (global-undo-tree-mode)
  (setq undo-tree-visualizer-diff t)
  (setq undo-tree-visualizer-timestamp t)
  (setq undo-tree-auto-save-history t)
  ;; https://www.reddit.com/r/emacs/comments/tejte0/undotree_bug_undotree_files_scattering_everywhere/?rdt=39892
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo"))))

;; for eglot snippet completion
(use-package yasnippet :ensure t)
(yas-global-mode 1)

;; Rust support
;; rustic-enable-detached-file-support seems to be problematic :(
(use-package rustic
  :ensure t
  :config
  (setq rustic-format-on-save t)
  (setq rustic-rustfmt-args "--edition 2018")
  (setq rustic-lsp-client 'eglot)
  ;; https://github.com/emacs-rustic/rustic/issues/99
  (put 'rustic-indent-offset 'safe-local-variable 'integerp)
  (add-hook 'rustic-mode-hook
            (lambda () (setq indent-tabs-mode nil))))

;; https://download.eclipse.org/jdtls/milestones/1.43.0/jdt-language-server-1.43.0-202412191447.tar.gz is the last language server that supports Debian 12 JDK
;; Untar the archive and symlink the jdtls binary in ~/.local/bin
(add-hook 'java-mode-hook 'eglot-ensure)

;; pipx install basedpyright
(add-hook 'python-mode-hook 'eglot-ensure)

;; The default setting is higher than strict, and complains (amongst others) about missing type annotations
(setq-default eglot-workspace-configuration
              '(:basedpyright (:typeCheckingMode "strict")
                              :basedpyright.analysis (:diagnosticSeverityOverrides (
                                                                                    :reportMissingParameterType "none"
                                                                                    :reportUnknownParameterType "none"
                                                                                    :reportUnknownVariableType "none"
                                                                                    :reportUnknownMemberType "none"
                                                                                    :reportUnknownArgumentType "none"))))

;; YAML support
(use-package yaml-mode :ensure t)

;; Puppet support; mostly for syntax highlighting
(use-package puppet-mode :ensure t)

(use-package terraform-mode :ensure t)
;; ubpkg terraform-ls
(add-hook 'terraform-mode-hook 'eglot-ensure)

;; Python notebooks
(use-package ein
  :ensure t
  :config
  (defvar ein:jupyter-default-notebook-directory (concat user-emacs-directory "ein")))

(use-package ledger-mode :ensure t)

;; Sometimes I like playing with Prolog
(setq prolog-system 'swi)
(setq auto-mode-alist (append '(("\\.pl\\'" . prolog-mode))
                              auto-mode-alist))

;; for typescript and tsx, use treesit-install-language-grammar to enable the built-in Emacs modes; interactive install is fine, see https://www.masteringemacs.org/article/how-to-get-started-tree-sitter
(add-hook 'tsx-ts-mode-hook 'eglot-ensure)
(add-hook 'typescript-ts-mode-hook 'eglot-ensure)

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '(tsx-ts-mode . ("npx" "typescript-language-server" "--stdio"))))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '(typescript-ts-mode . ("npx" "typescript-language-server" "--stdio"))))

(add-to-list 'auto-mode-alist '("\\.ts" . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.tsx" . tsx-ts-mode))

(use-package sql-indent
  :ensure t
  :config
  (add-hook 'sql-mode-hook 'sqlind-minor-mode))

;; the following is a bit fiddly, eglot requires some extra love to have extra flymake providers
(use-package flymake-vale
  :vc (:url "https://github.com/tpeacock19/flymake-vale.git"
            :rev :newest)
  :config
  (add-hook 'find-file-hook 'flymake-vale-maybe-load)
  (add-to-list 'flymake-vale-modes 'rustic-mode))

(setq eglot-stay-out-of '(flymake))
(add-hook 'eglot--managed-mode-hook (lambda ()
  (add-hook 'flymake-diagnostic-functions 'eglot-flymake-backend nil t)
  (flymake-mode 1)))
(add-hook 'markdown-mode-hook 'flymake-mode)
