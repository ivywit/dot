;;; ivy-debug -- Ivy Witter's debug configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:

;;
;; DAP debugging
;;
(use-package dap-mode
  :ensure t
  :config
  (dap-mode 1)
  (dap-ui-mode 1)
  (dap-tooltip-mode 1)
  (tooltip-mode 1))
;; (use-package dap-LANGUAGE) to load the dap adapter for your language
(use-package dap-firefox)
(use-package dap-node)
(use-package dap-php)


(provide 'ivy-debug)
;;; ivy-debug.el ends here
