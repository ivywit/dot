;;; ivy-org -- Ivy Witter's Org mode configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:

;;
;; Org mode
;;
(use-package org
  :ensure nil  ; built-in
  :mode ("\\.org\\'" . org-mode)
  :bind ("C-c a" . org-agenda)
  :custom
  (org-agenda-files (file-expand-wildcards "~/Dropbox/org/*.org"))
  (org-todo-keywords
   '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)" "CANCELLED(c)"))))

(provide 'ivy-org)
;;; ivy-org.el ends here
