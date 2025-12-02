;;; ivy-web -- Ivy Witter's Web configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:

;;
;; HTML mode
;;
(use-package html-mode
  :ensure nil  ; built-in (part of sgml-mode)
  :mode "\\.html?\\'"
  :hook (html-mode . lsp))

;;
;; CSS mode
;;
(use-package css-mode
  :ensure nil  ; built-in
  :mode "\\.css\\'")

(provide 'ivy-web)
;;; ivy-web.el ends here
