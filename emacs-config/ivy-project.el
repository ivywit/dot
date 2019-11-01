;;; ivy-project -- Ivy Witter's project configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:
(require 'ivy)
(require 'ag)
(require 'company)
(require 'prescient)
(require 'ivy-prescient)
(require 'company-prescient)
(require 'flycheck)
(require 'lsp-mode)
(require 'projectile)
(with-eval-after-load 'flycheck (require 'lsp-ui))
(with-eval-after-load 'company (require 'company-lsp))

(defvar projectile-mode-map)
(defvar projectile-completion-system)
(defvar projectile-register-project-type)
(defvar lsp-prefer-flymake)

(setq company-minimum-prefix-length 2)
(ivy-mode 1)
(global-company-mode)
(prescient-persist-mode 1)
(ivy-prescient-mode 1)
(company-prescient-mode 1)
(global-flycheck-mode)

(setq lsp-prefer-flymake nil)
(add-hook 'c-mode-common-hook 'lsp)

(with-eval-after-load 'ivy
  (projectile-mode +1)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (setq projectile-completion-system 'ivy))

(provide 'ivy-project)
;;; ivy-project.el ends here
