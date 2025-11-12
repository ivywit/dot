;;; ivy-git -- Ivy Witter's git configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:

(require 'magit)
(require 'magit-todos)
;; (require 'forge)
;; (defvar forge-alist)
;; (add-to-list 'forge-alist '("gitlab.corp.zulily.com" "gitlab.corp.zulily.com/api/v4" "gitlab.corp.zulily.com" forge-gitlab-repository))
(magit-todos-mode)

(provide 'ivy-git)
;;; ivy-git.el ends here
