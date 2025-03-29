;; symlink this file to ~/.emacs

;; Nicer defaults

(setq compilation-scroll-output t)
(setq column-number-mode t)               ; in the mode line
(setq-default show-trailing-whitespace t)
(setq org-startup-folded t)
(xterm-mouse-mode 1)

;; From https://www.emacswiki.org/emacs/SmoothScrolling#h5o-8
(setq scroll-step 1)
(setq scroll-conservatively 10000)
(setq auto-window-vscroll nil)

;; Do not spill temporary files everywhere
;; https://stackoverflow.com/a/18330742
(defvar --backup-directory (concat user-emacs-directory "backups"))
(if (not (file-exists-p --backup-directory))
        (make-directory --backup-directory t))
(setq backup-directory-alist `(("." . ,--backup-directory)))

;; Colorblind friendly theme.
(require-theme 'modus-themes)
(load-theme 'modus-vivendi :no-confirm)

;; From https://github.com/emacs-lsp/lsp-ui/issues/607 , silence some mouse hovering noise
(let ((areas '("mode-line" "left-margin" "left-fringe" "right-fringe" "header-line" "vertical-scroll-bar"))
          loc)
      (while areas
        (setq loc (pop areas))
        (global-set-key
         (kbd (concat "<" loc "> <mouse-movement>")) #'ignore)))

;; I use Emacs in the terminal, where x-pos|hide-tip is not defined. This masks errors :(
(defun x-pos-tip () nil)
(defun x-hide-tip () nil)

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

;; editorconfig simplifies adhering to code standards
(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

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

;; nicer completion UI
(use-package helm
  :ensure t
  :config
  (global-set-key (kbd "M-x") #'helm-M-x)
  (global-set-key (kbd "C-x C-f") #'helm-find-files)
  (global-set-key (kbd "C-x C-b") #'helm-mini)
  (setq helm-ff-skip-boring-files t))

;; learn keyboard shortcuts
(use-package which-key
  :ensure t
  :config
  (which-key-mode))

;; LSP base for Rust and Java
(use-package lsp-mode
  :ensure t
  :init
  ;; Windows Terminal has rendering issues with lenses?
  (setq lsp-lens-enable nil)
  :custom (lsp-rust-features "all"))

(use-package company
  :ensure t
  :config
  (add-hook 'after-init-hook 'global-company-mode))

(use-package lsp-ui
  :ensure t)
(use-package yasnippet
  :ensure t)

(yas-global-mode 1)

;; Rust support
(use-package rust-mode
  :ensure t
  :config
  (add-hook 'rust-mode-hook #'lsp)
  (add-hook 'rust-mode-hook
            (lambda () (setq indent-tabs-mode nil)))
  (setq rust-format-on-save t))

;; Python support
; https://github.com/jorgenschaefer/elpy/issues/1890#issuecomment-792361668
; Need to downgrade jedi to get it to work :(
(use-package elpy
  :ensure t
  :init
  (elpy-enable))

;;; Java Support
(use-package lsp-java
  :ensure t
  :config
  (add-hook 'java-mode-hook 'lsp)
  (add-hook 'java-mode-hook (lambda ()
                              (setq c-basic-offset 2
                                    indent-tabs-mode f))))

;; YAML support
(use-package yaml-mode
  :ensure t)

;; lsp-mode seems unusably slow, so don't install the Ansible language server
;; if you want to get it working, try https://www.reddit.com/r/emacs/comments/ybbkks/how_to_properly_set_up_lsp_ansible_language/itfxoaa/
(use-package ansible
  :ensure t
  :config
  (add-hook 'yaml-mode-hook 'ansible))

;; Puppet support; mostly for syntax highlighting

(use-package puppet-mode
  :ensure t)

(use-package ein :ensure t)

(use-package ledger-mode
  :ensure t)

;; Sometimes I like playing with Prolog
(setq prolog-system 'swi)
(setq auto-mode-alist (append '(("\\.pl\\'" . prolog-mode))
                              auto-mode-alist))

(add-hook 'markdown-mode-hook 'flymake-mode)
(add-hook 'rust-mode-hook 'flymake-mode)

(use-package flymake-vale
  :vc (:url "https://github.com/tpeacock19/flymake-vale.git"
            :rev :newest)
  :config
  (add-hook 'markdown-mode-hook #'flymake-vale-load)
  (add-hook 'rust-mode-hook #'flymake-vale-load)
  )
