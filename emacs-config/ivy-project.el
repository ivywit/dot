;;; ivy-project -- Ivy Witter's project configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:
(require 'lsp-mode)
(require 'prescient)
(require 'company)
(require 'company-prescient)
(require 'ivy)
(require 'ivy-prescient)
(require 'swiper)
(require 'ag)
(require 'flycheck)

(with-eval-after-load 'flycheck (require 'lsp-ui))
(with-eval-after-load 'company (require 'company-lsp))
(with-eval-after-load 'ivy (require 'lsp-ivy))

(prescient-persist-mode 1)

(global-company-mode)
(setq company-minimum-prefix-length 1
      company-idle-delay 0.0) ;; default is 0.2
(company-prescient-mode 1)

(global-flycheck-mode)

(add-hook 'c-mode-common-hook 'lsp)

(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(ivy-prescient-mode 1)
(setq enable-recursive-minibuffers t)

(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "<f6>") 'ivy-resume)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> o") 'counsel-describe-symbol)
(global-set-key (kbd "<f1> l") 'counsel-find-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c k") 'counsel-ag)
(global-set-key (kbd "C-x l") 'counsel-locate)
(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)

(provide 'ivy-project)
;;; ivy-project.el ends here
