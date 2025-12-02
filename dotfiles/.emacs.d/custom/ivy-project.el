;;; ivy-project -- Ivy Witter's project configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:

;;
;; Prescient - Intelligent sorting and filtering
;;
(use-package prescient
  :config
  (prescient-persist-mode 1))

;;
;; Company - Code completion
;;
(use-package company
  :hook (after-init . global-company-mode)
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-prescient
  :after company
  :config
  (company-prescient-mode 1))

;;
;; Flycheck - Syntax checking
;;
(use-package flycheck
  :hook (after-init . global-flycheck-mode))

;;
;; Ivy/Counsel/Swiper - Completion framework
;;
(use-package ivy
  :demand t
  :custom
  (ivy-use-virtual-buffers t)
  (enable-recursive-minibuffers t)
  :config
  (ivy-mode 1))

(use-package ivy-prescient
  :after ivy
  :config
  (ivy-prescient-mode 1))

(use-package counsel
  :demand t
  :bind (("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)
         ("<f1> f" . counsel-describe-function)
         ("<f1> v" . counsel-describe-variable)
         ("<f1> o" . counsel-describe-symbol)
         ("<f1> l" . counsel-find-library)
         ("<f2> i" . counsel-info-lookup-symbol)
         ("<f2> u" . counsel-unicode-char)
         ("C-c s" . counsel-rg)
         ("C-c g" . counsel-git)
         ("C-c j" . counsel-git-grep)
         ("C-c k" . counsel-ag)
         ("C-x l" . counsel-locate)
         ("C-S-o" . counsel-rhythmbox)
         :map minibuffer-local-map
         ("C-r" . counsel-minibuffer-history)))

(use-package swiper
  :bind (("C-s" . swiper)
         ("C-c C-r" . ivy-resume)
         ("<f6>" . ivy-resume)))

;;
;; Search tools
;;
(use-package ag
  :defer t)

(use-package rg
  :defer t)

;;
;; LSP Mode - Language Server Protocol
;;
(use-package lsp-mode
  :commands lsp
  :hook (c-mode-common . lsp)
  :custom
  (lsp-keymap-prefix "C-c l"))

(use-package lsp-ui
  :after (flycheck lsp-mode)
  :commands lsp-ui-mode)

(use-package lsp-ivy
  :after (ivy lsp-mode)
  :commands lsp-ivy-workspace-symbol)

(provide 'ivy-project)
;;; ivy-project.el ends here
