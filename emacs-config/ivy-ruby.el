;;; ivy-ruby -- Ivy Witter's ruby configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:

(defun setup-ruby ()
  "Setup ruby packages."
  (require 'inf-ruby)
  
  (lsp)
  (with-eval-after-load 'flycheck
    (flycheck-add-mode 'ruby-rubocop 'ruby-mode)
    (flycheck-add-next-checker 'lsp 'ruby-rubocop)))

(add-hook 'ruby-mode-hook 'setup-ruby)

(provide 'ivy-ruby)
;;; ivy-ruby.el ends here
