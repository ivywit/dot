;;; emacs-config -- Ivy Witter's configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:

;;
;;  Initialize Emacs with use-package
;;
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(setq package-archive-priorities
      '(("melpa" . 10)
	("gnu" . 5)))

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(use-package diminish :ensure t)
(use-package bind-key :ensure t)

;;
;;  IDE styles
;;
(use-package ivy-style
  :load-path "custom/")

;;
;;  Basic IDE configuration
;;
(use-package ivy-ide
  :load-path "custom/")

;;
;;  Project configuration
;;
(use-package ivy-project
  :load-path "custom/")

;;
;; Git management
;;
(use-package ivy-git
  :load-path "custom/")

;;
;;  JavaScript
;;
(use-package ivy-javascript
  :load-path "custom/")

;;
;;  PHP
;;
(use-package ivy-php
  :load-path "custom/")

;;
;;  Ruby
;;
(use-package ivy-ruby
  :load-path "custom/")

;;
;;  Config Files
;;
(use-package ivy-configuration
  :load-path "custom/")

;;
;;  GraphQL
;;
(use-package ivy-graphql
  :load-path "custom/")

;;
;;  Text Files
;;
(use-package ivy-text
  :load-path "custom/")

(provide '.emacs)
;;; .emacs ends here
