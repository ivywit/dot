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
  :ensure t)

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
