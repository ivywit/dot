;;; ivy-rust -- Ivy Witter's Rust configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:

;;
;; Rustic - Rust development environment
;;
(use-package rustic
  :mode "\\.rs\\'"
  :hook (rustic-mode . lsp)
  :config
  (with-eval-after-load 'flycheck
    (flycheck-add-mode 'rust-clippy 'rustic-mode)
    (flycheck-add-next-checker 'rust-cargo 'rust-clippy)))

(provide 'ivy-rust)
;;; ivy-rust.el ends here
