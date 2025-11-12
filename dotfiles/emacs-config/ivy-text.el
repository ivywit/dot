;;; ivy-text -- Ivy Witter's text file configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:

(require 'markdown-mode)
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.README\\'" . markdown-mode))

(provide 'ivy-text)
;;; ivy-text.el ends here
