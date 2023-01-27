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

(straight-use-package 'helm)

(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "C-x C-f") #'helm-find-files)
(global-set-key (kbd "C-x C-b") #'helm-mini)

(straight-use-package 'projectile)
(straight-use-package 'helm-projectile)

(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(helm-projectile-on)

(straight-use-package 'adoc-mode)

(straight-use-package
 '(flymake-vale :type git :host github :repo "tpeacock19/flymake-vale"))

(add-hook 'adoc-mode-hook #'flymake-vale-load)
(add-hook 'find-file-hook 'flymake-vale-maybe-load)
(add-hook 'adoc-mode-hook 'flymake-mode)

(straight-use-package 'lsp-mode)
(straight-use-package 'company-mode)
(straight-use-package 'lsp-ui)

(straight-use-package 'rust-mode)
(add-hook 'rust-mode-hook #'lsp)
(add-hook 'rust-mode-hook
          (lambda () (setq indent-tabs-mode nil)))
(setq rust-format-on-save t)

(straight-use-package 'elpy)
(elpy-enable)

(straight-use-package 'lsp-java)
(add-hook 'java-mode-hook 'lsp)

(straight-use-package 'yaml-mode)

;; lsp-mode seems unusably slow, so don't install the Ansible language server
;; if you want to get it working, try https://www.reddit.com/r/emacs/comments/ybbkks/how_to_properly_set_up_lsp_ansible_language/itfxoaa/
(straight-use-package 'ansible)
(add-hook 'yaml-mode-hook 'ansible)

;; mostly for syntax highlighting
(straight-use-package 'puppet-mode)

;; emacs 28 has modus themes, but EL9 only has emacs 27
(straight-use-package 'modus-themes)

(setq column-number-mode t)

(straight-use-package 'undo-tree)
(global-undo-tree-mode)
(setq undo-tree-visualizer-diff t)
(setq undo-tree-visualizer-timestamp t)
(setq undo-tree-auto-save-history t)
