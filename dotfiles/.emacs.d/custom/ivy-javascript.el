;;; ivy-javascript -- Ivy Witter's Javascript/TypeScript configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:

;;
;; JavaScript mode
;;
(use-package js-mode
  :ensure nil  ; built-in
  :mode "\\.jsx?\\'"
  :custom
  (js-indent-level 2)
  (js-switch-indent-offset 2)
  :hook ((js-mode . lsp)
         (js-mode . add-node-modules-path)))

;;
;; TypeScript mode
;;
(use-package typescript-mode
  :mode "\\.tsx?\\'"
  :custom
  (typescript-indent-level 2)
  :hook ((typescript-mode . lsp)
         (typescript-mode . add-node-modules-path))
  :config
  (setenv "TSSERVER_LOG_FILE" "/tmp/tsserver.log"))

;;
;; Add node_modules to path
;;
(use-package add-node-modules-path
  :defer t)

;;
;; ESLint automatic fixing
;;
(use-package eslint-fix
  :defer t
  :commands eslint-fix)

;;
;; DAP debugging for JavaScript/TypeScript
;;
(use-package dap-mode
  :defer t
  :config
  (require 'dap-firefox)
  (require 'dap-node))

;;
;; Flycheck configuration
;;
(with-eval-after-load 'flycheck
  (add-to-list 'flycheck-disabled-checkers 'javascript-jshint)
  (flycheck-add-mode 'javascript-eslint 'js-mode))

(provide 'ivy-javascript)
;;; ivy-javascript.el ends here
