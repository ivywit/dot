;;; ivy-text -- Ivy Witter's text file configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:

;;
;; Markdown mode
;;
(use-package markdown-mode
  :mode (("\\.md\\'" . markdown-mode)
         ("\\.README\\'" . markdown-mode)))

(provide 'ivy-text)
;;; ivy-text.el ends here
