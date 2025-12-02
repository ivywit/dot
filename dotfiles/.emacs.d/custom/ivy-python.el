;;; ivy-python -- Ivy Witter's python configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:

;;
;; Python mode with LSP
;;
(use-package python
  :ensure nil  ; built-in
  :mode ("\\.py\\'" . python-mode)
  :hook (python-mode . lsp)
  :config
  (with-eval-after-load 'lsp-mode
    (with-eval-after-load 'flycheck
      ;; Enable mypy and ruff checkers for python
      (flycheck-add-mode 'python-mypy 'python-mode)
      (flycheck-add-mode 'python-ruff 'python-mode)
      ;; Chain ruff after the LSP checker, then mypy
      (flycheck-add-next-checker 'lsp '(warning . python-ruff))
      (flycheck-add-next-checker 'python-ruff '(warning . python-mypy)))))

(provide 'ivy-python)
;;; ivy-python.el ends here
