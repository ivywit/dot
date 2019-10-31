;;; ivy-php -- Ivy Witter's Javascript configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:
;; (require 'phpactor)
;; (require 'company-phpactor)
(require 'php-mode)
(require 'web-mode)

(add-to-list 'auto-mode-alist '("\\.php\\'" . php-mode))
  ;; :hook ((php-mode . (lambda () (set (make-local-variable 'company-backends)
  ;;                                    '(;; list of backends
  ;;                                      company-phpactor
  ;;                                      company-files))))))

(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html\\.twig\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html\\.php\\'" . web-mode))
(setq web-mode-script-padding 2)
(setq web-mode-style-padding 2)
(setq web-mode-markup-indent-offset 4)
(setq web-mode-css-indent-offset 2)
(setq web-mode-code-indent-offset 2)
(add-hook 'php-mode-hook 'lsp)

(provide 'ivy-php)
;;; ivy-php.el ends here
