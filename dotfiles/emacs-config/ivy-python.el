;;; ivy-python -- Ivy Witter's python configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:

(defun setup-python ()
  "Setup python packages."
  (lsp)
    (with-eval-after-load 'flycheck
    (flycheck-add-mode 'python-mypy 'python-mode)
    (flycheck-add-next-checker 'lsp 'python-flake8)))

(add-hook 'python-mode-hook 'setup-python)

(provide 'ivy-python)
;;; ivy-python.el ends here
