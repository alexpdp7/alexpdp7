;; symlink this file to ~/.emacs

;; Nicer defaults

(setq compilation-scroll-output t)
(setq column-number-mode t)
(setq-default show-trailing-whitespace t)
(setq org-startup-folded t)

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
(load-theme 'modus-operandi :no-confirm)

(require 'use-package-ensure)
(setq use-package-always-ensure t)
(setq package-check-signature nil) ;; TODO: superconfigure lacks keyring?

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

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

;; nicer completion UI
(use-package helm
  :ensure t
  :config
  (global-set-key (kbd "M-x") #'helm-M-x)
  (global-set-key (kbd "C-x C-f") #'helm-find-files)
  (global-set-key (kbd "C-x C-b") #'helm-mini)
  (setq helm-ff-skip-boring-files t)
  (setq helm-ff-use-notify nil))  ; not working in Cosmopolitan

;; LSP base for Rust and Java
(use-package lsp-mode
  :ensure t)

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

;; ==== WORK ====

;; Abbrevs for work, declared in emacs.el for version control
(clear-abbrev-table global-abbrev-table)

(progn
  (when (boundp 'adoc-mode-abbrev-table)
    (clear-abbrev-table adoc-mode-abbrev-table))
  (define-abbrev-table 'adoc-mode-abbrev-table
    '(
      ("oomit" "_...output omitted..._")
)))

(setq save-abbrevs nil)

;; AsciiDoc + Vale + Aspell support for work
(use-package adoc-mode
  :ensure t
  :config
  (add-hook 'adoc-mode-hook #'abbrev-mode))

(cl-defun slot/vc-install (&key (fetcher "github") repo name rev backend)
  (let* ((url (format "https://www.%s.com/%s" fetcher repo))
         (iname (when name (intern name)))
         (pac-name (or iname (intern (file-name-base repo)))))
    (unless (package-installed-p pac-name)
      (package-vc-install url iname rev backend))))

(use-package flymake-vale
  :init (slot/vc-install :fetcher "github" :repo "tpeacock19/flymake-vale")
  :ensure t)

(add-hook 'adoc-mode-hook #'flymake-vale-load)
(add-hook 'find-file-hook 'flymake-vale-maybe-load)
(add-hook 'adoc-mode-hook 'flymake-mode)

(use-package flymake-aspell
  :ensure t)
(add-hook 'adoc-mode-hook #'flymake-aspell-setup)
(setq ispell-dictionary "en_US-RH")

(add-hook 'adoc-mode-hook (lambda () (setq flymake-aspell-aspell-mode "asciidoc")))
