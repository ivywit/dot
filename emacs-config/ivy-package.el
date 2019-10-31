;;; ivy-package -- Ivy Witter's package configuration
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

(provide 'ivy-package)
;;; ivy-package.el ends here
