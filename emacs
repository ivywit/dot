;;; emacs-config -- Ivy Witter's configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:
(add-to-list 'load-path "~/.emacs.d/custom")
(setq-default flycheck-emacs-lisp-load-path load-path)
(require 'ivy-package)
(require 'ivy-ide)
(require 'ivy-project)
(require 'ivy-debug)
(require 'ivy-git)
(require 'ivy-javascript)
(require 'ivy-php)
(require 'ivy-ruby)
(require 'ivy-configuration)
(require 'ivy-graphql)
(require 'ivy-text)

(defun mode-check (mode-name)
  "Check to eval MODE-NAME if a cons."
  (if (consp mode-name)
      (capitalize (car mode-name))
      ;;(mapconcat (lambda (x) (if (stringp x) (format 'x) (format x))) mode-name " ")
    (capitalize mode-name)))

(provide '.emacs)
;;; .emacs ends here

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-minimum-prefix-length 2)
 '(fringe-mode 0 nil (fringe))
 '(global-company-mode t)
 '(global-flycheck-mode t)
 '(global-hl-line-mode t)
 '(global-linum-mode t)
 '(global-visual-line-mode t)
 '(js2-missing-semi-one-line-override t)
 '(js2-strict-missing-semi-warning nil)
 '(linum-format 'linum-format-func)
 '(minimap-width-fraction 0.05)
 '(minimap-window-location 'right)
 '(mode-line-format
   (list "  ["
         (propertize "%p" 'face 'font-lock-constant-face)
         "/"
         (propertize "%I" 'face 'font-lock-constant-face)
         "] " " ("
         (propertize "%02l" 'face 'font-lock-keyword-face)
         ":"
         (propertize "%02c" 'face 'font-lock-keyword-face)
         ") "
         '(:eval
           (when vc-mode
             (propertize
              (substring vc-mode 5)
              'face 'font-lock-comment-face)))
         '(:eval
           (propertize "   %b " 'face
                       (let
                           ((face
                             (buffer-modified-p)))
                         (if face 'font-lock-warning-face 'font-lock-type-face))
                       'help-echo
                       (buffer-file-name)))
         '(:eval
           (propertize " " 'display
                       `((space :align-to
                                (-
                                 (+ right right-fringe right-margin)
                                 ,(+ 10
                                     (string-width
                                      (mode-check mode-name))))))))
         `(:eval
           (propertize
            (mode-check mode-name)
            'face 'font-lock-string-face))
         '(:eval
           (propertize
            (format-time-string " %H:%M ")
            'face 'font-lock-builtin-face))))
 '(package-selected-packages
   '(xclip json-mode add-node-modules-path indium eslint-fix swiper auto-compile hl-todo magit-todos typescript-mode tramp-term tramp-theme docker-tramp company-tern js2-mode flycheck company use-package))
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "black" :foreground "white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 100 :width normal :foundry "nil" :family "Hack"))))
 '(company-echo-common ((t (:foreground "mediumpurple"))))
 '(company-preview ((t (:background "royalblue4" :foreground "wheat"))))
 '(company-preview-common ((t (:inherit company-preview :foreground "mediumpurple1"))))
 '(company-scrollbar-bg ((t (:background "grey70"))))
 '(company-scrollbar-fg ((t (:background "mediumpurple1"))))
 '(company-template-field ((t (:background "grey20"))))
 '(company-tooltip ((t (:background "grey20"))))
 '(company-tooltip-common ((t (:foreground "mediumpurple4"))))
 '(cursor ((t (:background "white"))))
 '(custom-button ((t (:background "light steel blue" :foreground "black" :box (:line-width 2 :style released-button)))))
 '(custom-button-mouse ((t (:background "light sky blue" :foreground "black" :box (:line-width 2 :style released-button)))))
 '(custom-button-pressed ((t (:background "steelblue" :foreground "black" :box (:line-width 2 :style pressed-button)))))
 '(custom-variable-tag ((t (:foreground "RoyalBlue1" :weight bold))))
 '(error ((t (:foreground "tomato1" :weight bold))))
 '(flycheck-error-list-info ((t (:inherit coral))))
 '(flycheck-info ((t (:inherit warning :underline t))))
 '(font-lock-builtin-face ((t (:foreground "RoyalBlue1"))))
 '(font-lock-comment-face ((t (:foreground "grey40"))))
 '(font-lock-constant-face ((t (:foreground "goldenrod1"))))
 '(font-lock-doc-face ((t (:inherit font-lock-comment-face))))
 '(font-lock-function-name-face ((t (:foreground "goldenrod1"))))
 '(font-lock-keyword-face ((t (:foreground "MediumPurple1"))))
 '(font-lock-string-face ((t (:foreground "OliveDrab3"))))
 '(font-lock-type-face ((t (:foreground "SteelBlue1"))))
 '(font-lock-variable-name-face ((t (:foreground "dodgerblue1"))))
 '(highlight ((t (:background "gray10"))))
 '(highlight-symbol-face ((t (:background "grey40"))))
 '(js2-external-variable ((t (:foreground "SlateBlue1"))))
 '(js2-function-call ((t (:foreground "orange1"))))
 '(js2-function-param ((t (:foreground "dodger blue"))))
 '(js2-object-property ((t (:foreground "orchid1"))))
 '(js2-private-function-call ((t (:foreground "LightSalmon1"))))
 '(link ((t (:foreground "MediumPurple3" :underline t))))
 '(linum ((t (:background "black" :foreground "grey30" :box nil :underline nil))))
 '(menu ((t (:background "color-233" :foreground "dodger blue"))))
 '(minibuffer-prompt ((t (:foreground "dodger blue"))))
 '(minimap-active-region-background ((t (:background "grey20"))))
 '(mode-line ((t (:background "gray10" :foreground "dodger blue" :box (:line-width 2 :color "grey10")))))
 '(mode-line-inactive ((t (:inherit mode-line :background "grey30" :foreground "SlateBlue3" :box (:line-width 2 :color "grey30") :weight light))))
 '(region ((t (:background "mediumpurple4"))))
 '(rjsx-attr ((t (:inherit font-lock-preprocessor-face))))
 '(rjsx-tag ((t (:inherit font-lock-type-face))))
 '(rjsx-tag-bracket-face ((t (:foreground "brightblack"))))
 '(show-paren-match ((t (:background "gray40" :foreground "white" :weight bold))))
 '(vertical-border ((t (:background "color-233" :foreground "color-234"))))
 '(web-mode-html-tag-bracket-face ((t (:foreground " Snow4"))))
 '(window-divider ((t (:foreground "black")))))
