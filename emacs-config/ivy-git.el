;;; ivy-git -- Ivy Witter's git configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:

(use-package magit :ensure t)
(use-package magit-todos
  :ensure t
  :init (magit-todos-mode))

(use-package forge
  :ensure t
  :after magit
  :defines forge-alist
  :config
  (add-to-list 'forge-alist '("gitlab.corp.zulily.com" "gitlab.corp.zulily.com/api/v4" "gitlab.corp.zulily.com" forge-gitlab-repository)))


(provide 'ivy-git)
;;; ivy-git.el ends here
