;;; ivy-typescript -- Ivy Witter's Typescript configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:

(defun setup-tide ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

(use-package tide
  :ensure t
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . setup-tide)
         (typescript-mode . tide-hl-identifier-mode)
         (before-save . tide-format-before-save)))

;; add node modules to path
(use-package add-node-modules-path
  :ensure t
  :hook (typescript-mode))

;; Use prettier to keep code clean
(use-package prettier-js
  :ensure t
  :hook (typescript-mode . prettier-js-mode))

(provide 'ivy-typescript)
;;; ivy-typescript.el ends here
