;; symlink this file to ~/.emacs

;; Nicer defaults

(setq compilation-scroll-output t)
(setq column-number-mode t)               ; in the mode line
(setq-default show-trailing-whitespace t)
(setq org-startup-folded t)
(xterm-mouse-mode 1)
(save-place-mode t)

(setq custom-file "~/.emacs.d/disable-custom-variable-saving")

;; Do not spill temporary files everywhere
;; https://stackoverflow.com/a/18330742
(defvar --backup-directory (concat user-emacs-directory "backups"))
(if (not (file-exists-p --backup-directory))
        (make-directory --backup-directory t))
(setq backup-directory-alist `(("." . ,--backup-directory)))

;; Colorblind friendly theme.
(load-theme 'modus-vivendi :no-confirm)

(global-whitespace-mode)
(setopt whitespace-style '(tab-mark))

(require 'use-package-ensure)
(setq use-package-always-ensure t)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Install xclip so cutting/copying in Emacs on a terminal affects the graphical clipboard
(use-package xclip
  :ensure t
  :config
  (xclip-mode 1))

;; This does not respect things in JSON mode; see https://debbugs.gnu.org/cgi/bugreport.cgi?bug=72808 ; M-x use set-variable js-indent-level to override :\
(editorconfig-mode 1)

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

(fido-vertical-mode)

;; learn keyboard shortcuts
(which-key-mode)

; for eglot snippet completion
(use-package yasnippet :ensure t)

(yas-global-mode 1)

(global-completion-preview-mode 1)
(setq tab-always-indent 'complete)

;; Rust support
;; rustic-enable-detached-file-support seems to be problematic :(
(use-package rustic
  :ensure t
  :config
  (setq rustic-format-on-save t)
  (setq rustic-rustfmt-args "--edition 2018")
  (setq rustic-lsp-client 'eglot)
  (add-hook 'eglot--managed-mode-hook (lambda () (flymake-mode -1)))
  (add-hook 'rust-mode-hook (lambda () (setq indent-tabs-mode nil))))

;; https://download.eclipse.org/jdtls/milestones/1.43.0/jdt-language-server-1.43.0-202412191447.tar.gz is the last language server that supports Debian 12 JDK
;; Untar the archive and symlink the jdtls binary in ~/.local/bin
(add-hook 'java-mode-hook 'eglot-ensure)

;; Did not manage to make eglot work :(
(use-package elpy
  :ensure t
  :init
  (elpy-enable))

;; YAML support
(use-package yaml-mode :ensure t)

;; Puppet support; mostly for syntax highlighting
(use-package puppet-mode :ensure t)

;; Python notebooks
(use-package ein :ensure t)

(use-package ledger-mode :ensure t)

;; Sometimes I like playing with Prolog
(setq prolog-system 'swi)
(setq auto-mode-alist (append '(("\\.pl\\'" . prolog-mode))
                              auto-mode-alist))

(add-hook 'markdown-mode-hook 'flymake-mode)

(use-package flymake-vale
  :vc (:url "https://github.com/tpeacock19/flymake-vale.git"
            :rev :newest)
  :config
  (add-hook 'markdown-mode-hook #'flymake-vale-load)
  (add-hook 'rust-mode-hook #'flymake-vale-load)
  )
