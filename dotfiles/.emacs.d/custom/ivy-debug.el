;;; ivy-debug -- Ivy Witter's debug configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:

;;
;; DAP Mode - Debug Adapter Protocol
;;
(use-package dap-mode
  :defer t
  :config
  (dap-mode 1)
  (dap-ui-mode 1)
  (dap-tooltip-mode 1)
  (tooltip-mode 1))

(provide 'ivy-debug)
;;; ivy-debug.el ends here
