;;; ivy-javascript -- Ivy Witter's Javascript configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:

(defun setup-js ()
  "Setup basic js stuff."
  (defvar js-basic-indent)
  (defvar js-indent-level)
  (defvar flycheck-select-checker)
  (setq flycheck-select-checker "javascript-eslint")
  (setq js-basic-indent 2)
  (setq js-indent-level 2))

(defun setup-tide ()
  "Setup tide functionality."
  (interactive)
  (defvar flycheck-check-syntax-automatically)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

(add-hook 'js-mode-hook (setup-js))
(add-hook 'typescript-mode-hook (setup-js))

;; JS mode extension with js2
(use-package js2-mode
  :ensure t
  :hook (js-mode . js2-minor-mode))

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

(use-package tide
  :ensure t
  :after (company flycheck)
  :hook (((js-mode typescript-mode) . setup-tide)
         ((js-mode typescript-mode) . tide-hl-identifier-mode)
         (before-save . tide-format-before-save)))

;; add node modules to path
(use-package add-node-modules-path
  :ensure t
  :hook (js-mode typescript-mode))

;; Use prettier to keep code clean
(use-package prettier-js
  :ensure t
  :hook ((js-mode typescript-mode) . prettier-js-mode))

(provide 'ivy-javascript)
;;; ivy-javascript.el ends here
