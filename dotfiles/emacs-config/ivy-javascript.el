;;; ivy-javascript -- Ivy Witter's Javascript configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:

;; Setup basic js stuff.
(defvar js-basic-indent)
(defvar js-indent-level)
(defvar js-switch-indent-offset)
(defvar flycheck-disabled-checkers)
(defvar flycheck-add-mode)
(defvar flycheck-add-next-checker)
(defvar typescript-indent-level)
(setq js-basic-indent 2)
(setq js-indent-level 2)
(setq typescript-indent-level 2)
(setq js-switch-indent-offset 2)
(setenv "TSSERVER_LOG_FILE" "/tmp/tsserver.log")

(defun setup-dap ()
  "Setup dap."
  (with-eval-after-load 'dap
    (require 'dap-firefox)
    (require 'dap-node)))

(defun setup-eslint ()
  "Setup eslint."
  (require 'eslint-fix)
  (add-hook 'after-save-hook 'eslint-fix nil 'make-it-local)) ;; ESLint fix

(defun setup-node-modules ()
  "Setup node_modules packages."
  (require 'add-node-modules-path)
  (add-node-modules-path)) ;; add node modules to path

(defun setup-flycheck ()
  "Setup node_modules packages."
  (with-eval-after-load 'flycheck
    (add-to-list 'flycheck-disabled-checkers 'javascript-jshint)
    (flycheck-add-mode 'typescript-tslint 'ts-mode)
    (flycheck-add-mode 'javascript-eslint 'js-mode)
    (flycheck-add-next-checker 'lsp 'typescript-tslint 'javascript-eslint)))

(defun setup-copilot (language)
  "Setup copilot integration."
  (add-to-list 'copilot-major-mode-alist '(language)))

(defun setup (language)
  "Setup Javascript packages."
  (setup-dap)
  (setup-node-modules)
  ;;(setup-copilot language)
  (lsp))

(add-to-list 'auto-mode-alist '("\\.jsx?\\'" . js-mode))
(add-to-list 'auto-mode-alist '("\\.tsx?\\'" . typescript-mode))
(add-hook 'typescript-mode-hook (lambda () (setup "typescript")))
(add-hook 'js-mode-hook (lambda () (setup "javascript")))
;;(add-to-list 'auto-mode-alist '("\\.[jt]s[x]?\\'" . web-mode))
;;(add-hook 'web-mode-hook 'setup-js)

(provide 'ivy-javascript)
;;; ivy-javascript.el ends here
