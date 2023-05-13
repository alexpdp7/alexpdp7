;; symlink this file to ~/.emacs

;; if you get "End of file during parsing", refer to:
;;
;; https://github.com/radian-software/straight.el#debugging
;;
;; , particularly the note "Sometimes, in a corporate environment"... you
;; might need to clone straight.el into ~/.emacs.d manually

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Nicer defaults

(setq compilation-scroll-output t)
(setq column-number-mode t)
(setq-default show-trailing-whitespace t)

;; Colorblind friendly theme.
;; Emacs 28 has modus themes, but EL9 only has emacs 27

(straight-use-package 'modus-themes)
(require 'modus-themes)
(load-theme 'modus-operandi :no-confirm)

;; Install xclip so cutting/copying in Emacs on a terminal affects the graphical clipboard

(straight-use-package 'xclip)
(xclip-mode 1)

;; Fancy undo

(straight-use-package 'undo-tree)
(global-undo-tree-mode)
(setq undo-tree-visualizer-diff t)
(setq undo-tree-visualizer-timestamp t)
(setq undo-tree-auto-save-history t)

;; nicer completion UI

(straight-use-package 'helm)

(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "C-x C-f") #'helm-find-files)
(global-set-key (kbd "C-x C-b") #'helm-mini)

(setq helm-ff-skip-boring-files t)

;; nicer project support

(straight-use-package 'projectile)
(straight-use-package 'helm-projectile)

(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(helm-projectile-on)

;; LSP base for Rust and Java

(straight-use-package 'lsp-mode)
(straight-use-package 'company-mode)
(straight-use-package 'lsp-ui)
(straight-use-package 'yasnippet)

(yas-global-mode 1)

;; Rust support

(straight-use-package 'rust-mode)
(add-hook 'rust-mode-hook #'lsp)
(add-hook 'rust-mode-hook
          (lambda () (setq indent-tabs-mode nil)))
(setq rust-format-on-save t)

;; Python support

(straight-use-package 'elpy)
(elpy-enable)

;;; Java Support

(straight-use-package 'lsp-java)
(add-hook 'java-mode-hook 'lsp)

;; YAML support

(straight-use-package 'yaml-mode)

;; lsp-mode seems unusably slow, so don't install the Ansible language server
;; if you want to get it working, try https://www.reddit.com/r/emacs/comments/ybbkks/how_to_properly_set_up_lsp_ansible_language/itfxoaa/

(straight-use-package 'ansible)
(add-hook 'yaml-mode-hook 'ansible)

;; Puppet support; mostly for syntax highlighting

(straight-use-package 'puppet-mode)

;; ==== WORK ====

;; Abbrevs for work, declared in emacs.el for version control

(clear-abbrev-table global-abbrev-table)

(progn
  (when (boundp 'daoc-mode-abbrev-table)
    (clear-abbrev-table adoc-mode-abbrev-table))
  (define-abbrev-table 'adoc-mode-abbrev-table
    '(
      ("oomit" "_...output omitted..._")
)))

(set-default 'abbrev-mode t)

(setq save-abbrevs nil)

;; AsciiDoc + Vale + Aspell support for work

(straight-use-package 'adoc-mode)

(straight-use-package
 '(flymake-vale :type git :host github :repo "tpeacock19/flymake-vale"))

(add-hook 'adoc-mode-hook #'flymake-vale-load)
(add-hook 'find-file-hook 'flymake-vale-maybe-load)
(add-hook 'adoc-mode-hook 'flymake-mode)

(straight-use-package 'flymake-aspell)
(add-hook 'adoc-mode-hook #'flymake-aspell-setup)
(setq ispell-dictionary "en_US-RH")

(add-hook 'adoc-mode-hook (lambda () (setq flymake-aspell-aspell-mode "asciidoc")))
