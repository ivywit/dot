;;; ivy-javascript -- Ivy Witter's Javascript configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:

;; Setup basic js stuff.
(defvar js-basic-indent)
(defvar js-indent-level)
(setq js-basic-indent 2)
(setq js-indent-level 2)

;; TS support
(use-package typescript-mode
  :mode "\\.tsx?\\'"
  :ensure t
  :config
  (setq-default typescript-indent-level 2))


;; JS interpreter and debugger
(use-package indium
  :ensure t
  :hook ((js-mode typescript-mode) . indium-interaction-mode))

;; add node modules to path
(use-package add-node-modules-path
  :ensure t
  :hook (js-mode typescript-mode))

(provide 'ivy-javascript)
;;; ivy-javascript.el ends here
