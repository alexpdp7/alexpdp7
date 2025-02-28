;; archive of some stuff I used in a previous job

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

(use-package flymake-vale
  :vc (:url "https://github.com/tpeacock19/flymake-vale.git"
            :rev :newest)
  :config
  (add-to-list 'flymake-vale-modes 'adoc-mode)
  (add-hook 'find-file-hook 'flymake-vale-maybe-load)
  )

(use-package flymake-aspell
  :ensure t)
(add-hook 'adoc-mode-hook #'flymake-aspell-setup)
(setq ispell-dictionary "en_US-RH")

(add-hook 'adoc-mode-hook (lambda () (setq flymake-aspell-aspell-mode "asciidoc")))
