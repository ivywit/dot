;;; ivy-git -- Ivy Witter's git configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:

(require 'magit)
(with-eval-after-load 'magit
  (require 'magit-todos)
  (require 'forge)
  (magit-todos-mode)
  (defvar forge-alist)
  (add-to-list 'forge-alist '("gitlab.corp.zulily.com" "gitlab.corp.zulily.com/api/v4" "gitlab.corp.zulily.com" forge-gitlab-repository)))

(provide 'ivy-git)
;;; ivy-git.el ends here
