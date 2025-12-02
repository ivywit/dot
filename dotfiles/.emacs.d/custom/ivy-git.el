;;; ivy-git -- Ivy Witter's git configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:

;;
;; Magit - Git porcelain for Emacs
;;
(use-package magit
  :defer t
  :bind ("C-x g" . magit-status))

;;
;; Magit Todos - Show TODOs in magit status
;;
(use-package magit-todos
  :after magit
  :config
  (magit-todos-mode 1))

(provide 'ivy-git)
;;; ivy-git.el ends here
