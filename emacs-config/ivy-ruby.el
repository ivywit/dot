;;; ivy-ruby -- Ivy Witter's ruby configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:

(defun setup-ruby ()
  "Setup ruby packages."
  (require 'projectile-rails)
  (require 'inf-ruby)
  (require 'robe)
  (require 'rvm)
  (defadvice inf-ruby-console-auto
      (before activate-rvm-for-robe activate)
    "."
    (rvm-activate-corresponding-ruby))
  (lsp)
  (robe-mode)
  (projectile-rails-mode))

(add-hook 'ruby-mode-hook 'setup-ruby)

(provide 'ivy-ruby)
;;; ivy-ruby.el ends here
