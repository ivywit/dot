;;; emacs-config -- Ivy Witter's configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:
(add-to-list 'load-path "~/.emacs.d/custom/")
(add-to-list 'load-path "~/.emacs.d/codeium.el")
(setq-default flycheck-emacs-lisp-load-path load-path)
(require 'ivy-package)
(require 'ivy-ide)
(require 'ivy-project)
(require 'ivy-debug)
(require 'ivy-git)
(require 'ivy-javascript)
(require 'ivy-php)
(require 'ivy-ruby)
(require 'ivy-python)
(require 'ivy-configuration)
(require 'ivy-graphql)
(require 'ivy-text)
(require 'ivy-css)
(require `ivy-org)
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
 '(auto-compile-use-mode-line 'mode-line-modified)
 '(codeium/metadata/api_key "88874712-c19d-43bf-a6be-641fae7f93ef")
 '(company-minimum-prefix-length 2)
 '(font-lock-global-modes '(not speedbar-mode))
 '(fringe-mode 0 nil (fringe))
 '(global-company-mode t)
 '(global-flycheck-mode t)
 '(global-hl-line-mode t)
 '(global-linum-mode t)
 '(global-visual-line-mode t)
 '(linum-format 'linum-format-func)
 '(magit-todos-insert-after '(bottom) nil nil "Changed by setter of obsolete option `magit-todos-insert-at'")
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
                                 ,(+ 1
                                     (string-width
                                      (mode-check mode-name))))))))
         `(:eval
           (propertize
            (mode-check mode-name)
            'face 'font-lock-string-face))))
 '(org-agenda-files '("~/Dropbox/org/20220519.org") t)
 '(package-selected-packages
   '(pos-tip lsp-mode lsp-ui jsonrpc editorconfig rustic rg org yasnippet counsel circe circe-notifications lsp-ivy gitlab ivy-gitlab gitlab-ci-mode-flycheck gitlab-ci-mode xclip json-mode add-node-modules-path indium eslint-fix swiper auto-compile hl-todo magit-todos tramp-term tramp-theme docker-tramp flycheck company))
 '(show-paren-mode t)
 '(warning-suppress-types '((lsp-mode) (lsp-mode) (lsp-mode)))
 '(web-mode-code-indent-offset 2)
 '(web-mode-css-indent-offset 2)
 '(web-mode-markup-indent-offset 2)
 '(web-mode-script-padding 2)
 '(web-mode-style-padding 2))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :extend nil :stipple nil :background "gray3" :foreground "LightGray" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 1 :width normal :foundry "default" :family "default"))))
 '(company-echo-common ((t (:foreground "MediumPurple"))))
 '(company-preview ((t (:background "RoyalBlue4" :foreground "wheat"))))
 '(company-preview-common ((t (:inherit company-preview :foreground "MediumPurple1"))))
 '(company-template-field ((t (:background "grey20"))))
 '(company-tooltip ((t (:background "grey20"))))
 '(company-tooltip-common ((t (:foreground "MediumPurple4"))))
 '(company-tooltip-scrollbar-thumb ((t (:background "MediumPurple1"))))
 '(company-tooltip-scrollbar-track ((t (:background "grey70"))))
 '(cursor ((t (:background "white"))))
 '(custom-button ((t (:background "LightSteelBlue" :foreground "black" :box (:line-width 2 :style released-button)))))
 '(custom-button-mouse ((t (:background "LightSkyBlue" :foreground "black" :box (:line-width 2 :style released-button)))))
 '(custom-button-pressed ((t (:background "SteelBlue" :foreground "black" :box (:line-width 2 :style pressed-button)))))
 '(custom-variable-tag ((t (:foreground "RoyalBlue1" :weight bold))))
 '(error ((t (:foreground "firebrick" :weight bold))))
 '(flycheck-error-list-info ((t (:inherit coral))))
 '(flycheck-info ((t (:inherit warning :underline t))))
 '(font-lock-builtin-face ((t (:foreground "RoyalBlue"))))
 '(font-lock-comment-face ((t (:foreground "grey40"))))
 '(font-lock-constant-face ((t (:foreground "goldenrod2"))))
 '(font-lock-doc-face ((t (:inherit font-lock-comment-face))))
 '(font-lock-function-name-face ((t (:foreground "goldenrod1"))))
 '(font-lock-keyword-face ((t (:foreground "MediumPurple1"))))
 '(font-lock-string-face ((t (:foreground "DarkOliveGreen3"))))
 '(font-lock-type-face ((t (:foreground "Goldenrod2"))))
 '(font-lock-variable-name-face ((t (:foreground "DodgerBlue1"))))
 '(highlight ((t (:background "black"))))
 '(highlight-symbol-face ((t (:background "grey40"))))
 '(line-number ((t (:foreground "gray25"))))
 '(line-number-current-line ((t (:inherit line-number :background "black"))))
 '(link ((t (:foreground "MediumPurple3" :underline t))))
 '(linum ((t (:background "gray3" :foreground "gray20" :box nil :underline nil))))
 '(menu ((t (:background "gray8" :foreground "DodgerBlue"))))
 '(minibuffer-prompt ((t (:foreground "DodgerBlue"))))
 '(minimap-active-region-background ((t (:background "grey20"))))
 '(mode-line ((t (:background "gray8" :foreground "SlateBlue3" :box (:line-width 2 :color "grey10")))))
 '(mode-line-inactive ((t (:inherit mode-line :background "gray20" :foreground "SlateBlue4" :box (:line-width 2 :color "grey30") :weight light))))
 '(region ((t (:background "Mediumpurple4"))))
 '(show-paren-match ((t (:background "MediumPurple" :foreground "black" :weight bold))))
 '(vertical-border ((t (:background "gray8" :foreground "gray10"))))
 '(web-mode-html-attr-name-face ((t (:foreground "DodgerBlue"))))
 '(web-mode-html-tag-bracket-face ((t (:foreground " Snow4"))))
 '(web-mode-html-tag-face ((t (:foreground "SkyBlue"))))
 '(window-divider ((t (:foreground "black")))))
