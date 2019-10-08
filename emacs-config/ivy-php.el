;;; ivy-php -- Ivy Witter's Javascript configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:
;; (use-package phpactor
;;   :ensure t)

;; (use-package company-phpactor
;;   :ensure t)

(use-package php-mode
  :mode "\\.php\\'"
  :interpreter "php"
  :ensure t
  :defines company-backends)
  ;; :hook ((php-mode . (lambda () (set (make-local-variable 'company-backends)
  ;;                                    '(;; list of backends
  ;;                                      company-phpactor
  ;;                                      company-files))))))

(use-package web-mode
  :mode ("\\.html?\\'" "\\.phtml\\'" "\\.tpl\\.php\\'" "\\.html\\.twig\\'" "\\.html\\.php\\'")
  :ensure t
  :config
  (setq web-mode-script-padding 2)
  (setq web-mode-style-padding 2)
  (setq web-mode-markup-indent-offset 4)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2))

(provide 'ivy-php)
;;; ivy-php.el ends here
