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
