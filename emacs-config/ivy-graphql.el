;;; ivy-graphql -- Ivy Witter's GraphQL configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:

;; graphql schema support

(require 'graphql-mode)
(add-to-list 'auto-mode-alist '("\\.graphql\\'" . graphql-mode))

(provide 'ivy-graphql)
;;; ivy-graphql.el ends here
