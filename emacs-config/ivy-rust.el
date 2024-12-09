;;; ivy-rust -- Ivy Witter's Rust configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:


(defun setup-rust ()
  "Setup rust packages."
  (require 'rustic)
  (lsp)
  (with-eval-after-load 'flycheck
    (flycheck-add-mode 'rust-clippy 'rust-mode)
    (flycheck-add-next-checker 'rust-cargo 'rust-clippy 'rust)))

(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode))
(add-hook 'rust-mode-hook 'setup-rust)

(provide 'ivy-rust)
;;; ivy-rust.el ends here
