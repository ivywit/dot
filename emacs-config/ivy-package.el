;;; ivy-package -- Ivy Witter's package configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:

;;
;;  Initialize Emacs with use-package
;;
(setq load-prefer-newer t)
(require 'auto-compile)
(require 'package)
(setq package-enable-at-startup nil)
(auto-compile-on-load-mode)
(auto-compile-on-save-mode)

(provide 'ivy-package)
;;; ivy-package.el ends here
