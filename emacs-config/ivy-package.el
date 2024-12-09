;;; ivy-package -- Ivy Witter's package configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:
(require 'package)
(defvar package-list)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(setq package-archive-priorities
      '(("melpa" . 10)
	("gnu" . 5)))
(setq load-prefer-newer t)

; list the packages you want
(setq package-list '(add-node-modules-path
                     auto-compile
                     comment-tags
                     company
                     company-prescient
                     counsel
                     dap-mode
                     emacsql
                     eslint-fix
                     flycheck
                     graphql-mode
                     highlight-symbol
                     hl-todo
                     inf-ruby
                     ivy
                     ivy-prescient
;;                     json-mode
                     lsp-ivy
                     lsp-mode
                     lsp-ui
                     magit
                     magit-todos
                     org
                     php-mode
                     prescient
                     projectile
                     rg
                     robe
                     rotate
                     rustic
                     swiper
                     tramp
                     typescript-mode
                     web-mode
                     xclip
                     yaml-mode
                     yasnippet))

; activate all the packages (in particular autoloads)
(package-initialize)

; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

(require 'auto-compile)
(auto-compile-on-load-mode)
(auto-compile-on-save-mode)

(provide 'ivy-package)
;;; ivy-package.el ends here
