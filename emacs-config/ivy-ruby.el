;;; ivy-ruby -- Ivy Witter's ruby configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:

(use-package robe
  :ensure t
  :hook (ruby-mode . robe-mode)
  :config
  (defadvice inf-ruby-console-auto
      (before activate-rvm-for-robe activate)
    (rvm-activate-corresponding-ruby)))

(use-package projectile-rails
  :ensure t
  :hook (ruby-mode . projectile-rails-mode))

(use-package inf-ruby
  :ensure t
  :defer t)

(use-package rvm
  :ensure t)

(provide 'ivy-ruby)
;;; ivy-ruby.el ends here
