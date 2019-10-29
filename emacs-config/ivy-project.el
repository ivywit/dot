;;; ivy-project -- Ivy Witter's project configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:

;;
;;  Ivy
;;
(use-package ivy
  :ensure t
  :functions ivy-mode
  :config
  (ivy-mode 1))

;;
;;  Ag Search
;;
(use-package ag
  :ensure t)

;;
;;  Company Mode
;;
(use-package company
  :ensure t
  :init (global-company-mode)
  :config (setq company-minimum-prefix-length 2))

;;
;;  Prescient
;;
(use-package prescient
  :ensure t
  :functions prescient-persist-mode
  :config
  (prescient-persist-mode 1))

(use-package ivy-prescient
  :ensure t
  :functions ivy-prescient-mode
  :config
  (ivy-prescient-mode 1))

(use-package company-prescient
  :ensure t
  :defines company-prescient-mode
  :config
  (company-prescient-mode 1))

;;
;;  Fly Check
;;
(use-package flycheck
  :ensure t
  :defines flycheck-disable-checkers
  :functions flycheck-add-mode
  :config
  (global-flycheck-mode)
  (add-to-list 'flycheck-disabled-checkers 'javascript-jshint)
  (flycheck-add-mode 'javascript-eslint 'js-mode))

;;
;; LSP
;;
(use-package lsp-mode
  :ensure t
  :hook ((js-mode c-mode-common ruby-mode php-mode) . lsp)
  :init (setq lsp-prefer-flymake nil)
  :commands lsp)

(use-package lsp-ui
  :ensure t
  :after (lsp-mode flycheck)
  :commands lsp-ui-mode)

(use-package company-lsp
  :ensure t
  :after (lsp-mode company)
  :commands company-lsp)

;;
;;  Projectile
;;
(use-package projectile
  :ensure t
  :after ivy
  :bind-keymap ("C-c p". projectile-command-map)
  :functions projectile-register-project-type
  :defines projectile-completion-system
  :config
  (projectile-mode +1)
  (setq projectile-completion-system 'ivy)
  (projectile-register-project-type 'javascript '("package.json")
                                    :compile "npm install"
                                    :test "npm test"
                                    :run "npm start"
                                    :test-suffix ".spec"))

(provide 'ivy-project)
;;; ivy-project.el ends here
