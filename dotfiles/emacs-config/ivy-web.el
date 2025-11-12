;;; ivy-web -- Ivy Witter's Web configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:

(defvar web-mode-content-types-alist)


(defun setup-web ()
  "Setup web packages."
  (lsp))
  ;; (with-eval-after-load 'flycheck
  ;;   (flycheck-add-mode 'javascript-eslint 'js-mode)))

(add-hook 'html-mode-hook 'setup-web)
(add-to-list 'auto-mode-alist '("\\.html?\\'" . html-mode))
(add-to-list 'auto-mode-alist '("\\.css?\\'" . css-mode))
;; (setq web-mode-content-types-alist
;;       '(("jsx" . "\\.[jt]s[x]?\\'")
;;         ("html" . "\\.html?\\'")
;;         ("css" . "\\.css\\'")))

(provide 'ivy-web)
;;; ivy-web.el ends here
