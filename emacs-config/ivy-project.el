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

(provide 'ivy-project)
;;; ivy-project.el ends here
