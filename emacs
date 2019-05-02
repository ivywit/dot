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
;;  Basic IDE configuration
;;
(use-package ivy-ide
  :load-path "ivy-configs/")

;;
;;  JavaScript
;;
(use-package ivy-javascript
  :load-path "ivy-configs/")

;;
;;
;;
(use-package ivy-php
  :load-path "ivy-configs/")

;;
;;  Config Files
;;
(use-package ivy-configuration
  :load-path "ivy-configs")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(global-hl-line-mode t)
 '(global-linum-mode t)
 '(linum-format (quote linum-format-func))
 '(mode-line-format
   (list " ["
         (propertize "%p"
                     (quote face)
                     (quote font-lock-constant-face))
         "/"
         (propertize "%I"
                     (quote face)
                     (quote font-lock-constant-face))
         "] " " ("
         (propertize "%02l"
                     (quote face)
                     (quote font-lock-keyword-face))
         ":"
         (propertize "%02c"
                     (quote face)
                     (quote font-lock-keyword-face))
         ") "
         (quote
          (:eval
           (propertize
            (substring vc-mode 5)
            (quote face)
            (quote font-lock-comment-face))))
         (quote
          (:eval
           (propertize "   %b "
                       (quote face)
                       (let
                           ((face
                             (buffer-modified-p)))
                         (if face
                             (quote font-lock-warning-face)
                           (quote font-lock-type-face)))
                       (quote help-echo)
                       (buffer-file-name))))
         (quote
          (:eval
           (propertize " "
                       (quote display)
                       (\`
                        ((space :align-to
                                (-
                                 (+ right right-fringe right-margin)
                                 (\,
                                  (+ 10
                                     (string-width mode-name))))))))))
         (propertize " %m "
                     (quote face)
                     (quote font-lock-string-face))
         (quote
          (:eval
           (propertize
            (format-time-string " %H:%M ")
            (quote face)
            (quote font-lock-builtin-face))))))
 '(package-selected-packages
   (quote
    (company-tern js2-mode flycheck company use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-variable-tag ((t (:foreground "color-69" :weight bold))))
 '(error ((t (:foreground "red" :weight bold))))
 '(font-lock-builtin-face ((t (:foreground "color-69"))))
 '(font-lock-comment-face ((t (:foreground "brightblack"))))
 '(font-lock-constant-face ((t (:foreground "color-142"))))
 '(font-lock-doc-face ((t (:inherit font-lock-comment-face))))
 '(font-lock-function-name-face ((t (:foreground "color-172"))))
 '(font-lock-keyword-face ((t (:foreground "color-105"))))
 '(font-lock-string-face ((t (:foreground "color-106"))))
 '(font-lock-type-face ((t (:foreground "color-36"))))
 '(font-lock-variable-name-face ((t (:foreground "color-39"))))
 '(highlight ((t (:background "color-234"))))
 '(js2-external-variable ((t (:foreground "color-136"))))
 '(js2-function-call ((t (:foreground "color-172"))))
 '(js2-function-param ((t (:foreground "dodger blue"))))
 '(js2-private-function-call ((t (:foreground "color-183"))))
 '(link ((t (:foreground "color-99" :underline t))))
 '(linum ((t (:foreground "color-235" :background "black"))))
 '(menu ((t (:background "color-233" :foreground "dodger blue"))))
 '(minibuffer-prompt ((t (:foreground "dodger blue"))))
 '(mode-line ((t (:background "color-234" :foreground "dodger blue" :box (:line-width 8 :style released-button)))))
 '(mode-line-inactive ((t (:inherit mode-line :background "color-234" :foreground "color-92" :box (:line-width 8 :color "grey75") :weight light))))
 '(region ((t (:background "color-54"))))
 '(rjsx-attr ((t (:inherit font-lock-preprocessor-face))))
 '(rjsx-tag ((t (:inherit font-lock-type-face))))
 '(rjsx-tag-bracket-face ((t (:foreground "brightblack"))))
 '(vertical-border ((t (:background "color-233" :foreground "color-234"))))
 '(web-mode-html-tag-bracket-face ((t (:foreground " Snow4"))))
 '(window-divider ((t (:foreground "color-234")))))

(provide '.emacs)
;;; .emacs ends here
