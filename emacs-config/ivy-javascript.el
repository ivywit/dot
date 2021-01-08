;;; ivy-javascript -- Ivy Witter's Javascript configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:

;; Setup basic js stuff.
(defvar js-basic-indent)
(defvar js-indent-level)
(defvar typescript-indent-level)
(defvar js-switch-indent-offset)
(setq js-basic-indent 2)
(setq js-indent-level 2)
(setq typescript-indent-level 2)
(setq js-switch-indent-offset 2)
(setenv "TSSERVER_LOG_FILE" "/tmp/tsserver.log")

(defun setup-js ()
  "Setup Javascript packages."
  (require 'eslint-fix)
  (require 'add-node-modules-path)

  (defvar flycheck-disabled-checkers)
  
  (lsp)

  (with-eval-after-load 'flycheck
    (add-to-list 'flycheck-disabled-checkers 'javascript-jshint)
    (flycheck-add-mode 'javascript-eslint 'js-mode)
    (flycheck-add-next-checker 'lsp 'javascript-eslint))

  (with-eval-after-load 'dap
    (require 'dap-firefox)
    (require 'dap-node))
  
  (add-node-modules-path) ;; add node modules to path
  (add-hook 'after-save-hook 'eslint-fix nil 'make-it-local)) ;; ESLint fix

(add-to-list 'auto-mode-alist '("\\.jsx?\\'" . js-mode))
(add-to-list 'auto-mode-alist '("\\.tsx?\\'" . typescript-mode))
(add-hook 'typescript-mode-hook 'setup-js)
(add-hook 'js-mode-hook 'setup-js)
;;(add-to-list 'auto-mode-alist '("\\.[jt]s[x]?\\'" . web-mode))
;;(add-hook 'web-mode-hook 'setup-js)

(provide 'ivy-javascript)
;;; ivy-javascript.el ends here
