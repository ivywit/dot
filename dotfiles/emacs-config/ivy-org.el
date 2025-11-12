;;; ivy-org -- Ivy Witter's Org mode configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:
(defvar org-todo-keywords)
(defvar org-agenda-files)
(setq org-agenda-files
    (file-expand-wildcards "~/Dropbox/org/*.org"))
(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)" "CANCELLED(c)")))
(global-set-key (kbd "C-c a") 'org-agenda)

(provide 'ivy-org)
;;; ivy-org.el ends here
