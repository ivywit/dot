;;; ivy-php -- Ivy Witter's Javascript configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:

(use-package php-mode
  :mode "\\.php\\'"
  :interpreter "php"
  :ensure t)

(use-package web-mode
  :mode ("\\.html?\\'" "\\.phtml\\'" "\\.tpl\\.php\\'" "\\.html\\.twig\\'" "\\.html\\.php\\'")
  :ensure t
  :config
  (setq web-mode-script-padding 2)
  (setq web-mode-style-padding 2)
  (setq web-mode-markup-indent-offset 4)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2))

(use-package phpactor
  :ensure t
  :hook (php-mode))

(use-package company-phpactor
  :ensure t
  :hook (php-mode . (lambda ()
                      (defvar company-backends)
                      (set (make-local-variable 'company-backends)
                           '(;; list of backends
                             company-phpactor
                             company-files)))))

(provide 'ivy-php)
;;; ivy-php.el ends here
