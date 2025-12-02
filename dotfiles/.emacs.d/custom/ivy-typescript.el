;;; ivy-typescript -- Ivy Witter's Typescript configuration (Tide alternative)
;;; Commentary:
;; This file provides Tide (TypeScript Interactive Development Environment)
;; as an alternative or complement to LSP for TypeScript
;;
;;; Code:

;;
;; Tide - TypeScript IDE
;;
(defun setup-tide ()
  "Setup Tide for TypeScript development."
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (company-mode +1))

(use-package tide
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . setup-tide)
         (typescript-mode . tide-hl-identifier-mode)
         (before-save . tide-format-before-save)))

(provide 'ivy-typescript)
;;; ivy-typescript.el ends here
