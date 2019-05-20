;;; ivy-javascript -- Ivy Witter's Javascript configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:

;; JS2 and JSX support
(use-package rjsx-mode
  :mode "\\.jsx?\\'"
  :magic ".* node"
  :interpreter "javascript"
  :ensure t
  :init
  (defvar js-basic-indent)
  (defvar js-indent-level)
  (defvar flycheck-select-checker)
  (setq flycheck-select-checker "javascript-eslint")
  (setq js-basic-indent 2)
  (setq js-indent-level 2)
  (setq-default js2-basic-indent 2
                js2-basic-offset 2
                js2-auto-indent-p t
                js2-cleanup-whitespace t
                js2-enter-indents-newline t
                js2-indent-on-enter-key t
                js2-strict-missing-semi-warning nil
                js2-missing-semi-one-line-override t
                js2-global-externs (list "window" "module" "require" "buster" "sinon" "assert" "refute" "setTimeout" "clearTimeout" "setInterval" "clearInterval" "location" "__dirname" "console" "JSON" "jQuery" "$")))

;; JS Autocomplete and correct
(use-package tern
  :defer t
  :ensure t
  :hook (rjsx-mode . tern-mode)
  :config
  (setq tern-command (append tern-command '("--no-port-file"))))

(use-package company-tern
  :after (company tern)
  :ensure t
  :config
  (add-to-list 'company-backends 'company-tern))

;; JS Refactoring
(use-package js2-refactor
  :ensure t
  :hook (rjsx-mode . js2-refactor-mode)
  :init
  (js2r-add-keybindings-with-prefix "C-c C-f"))

;; JS referece definition
(use-package xref-js2
  :ensure t
  :hook (rjsx-mode . (lambda ()
		      (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t)))
  :config
  (define-key js-mode-map (kbd "M-.") nil))

;; JS interpreter and debugger
(use-package indium
  :ensure t
  :hook (rjsx-mode . indium-interaction-mode))

;; add node modules to path
(use-package add-node-modules-path
  :ensure t
  :hook (rjsx-mode))

;; Use prettier to keep code clean
(use-package prettier-js
  :ensure t
  :hook (rjsx-mode . prettier-js-mode))

(provide 'ivy-javascript)
;;; ivy-javascript.el ends here
