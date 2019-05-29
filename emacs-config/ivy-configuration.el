;;; ivy-configuration -- Ivy Witter's IDE configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:

(use-package json-mode
  :mode "\\.json\\'"
  :interpreter "json"
  :ensure t)

(use-package yaml-mode
  :mode "\\.ym*l\\'"
  :interpreter "yaml"
  :ensure t)

(provide 'ivy-configuration)
;;; ivy-configuration.el ends here
