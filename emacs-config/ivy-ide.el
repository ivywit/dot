;;; ivy-ide -- Ivy Witter's IDE configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:
(require 'mouse)
(require 'rotate)
(require 'hl-line)
(require 'comment-tags)
(require 'highlight-symbol)
(require 'paren)
(require 'tramp)
(require 'hideshow)
(require 'xclip)

;; (when (memq window-system '(mac ns x))
;;   (require 'exec-path-from-shell)
;;   (exec-path-from-shell-initialize))

(defvar ns-use-proxy-icon)
(defvar mouse-sel-mode)
(defvar docker-tramp-use-names)

;;
;;  Copy and Paste
;;
(xclip-mode 1)

;;
;;  Copilot mode
;;

; modify company-mode behaviors
;; (with-eval-after-load 'company
;;   ; disable inline previews
;;   (delq 'company-preview-if-just-one-frontend company-frontends)
;;   ; enable tab completion
;;   (define-key company-mode-map (kbd "<tab>") 'my-tab)
;;   (define-key company-mode-map (kbd "TAB") 'my-tab)
;;   (define-key company-active-map (kbd "<tab>") 'my-tab)
;;   (define-key company-active-map (kbd "TAB") 'my-tab))
;;(copilot-mode 1)

(global-set-key (kbd "C-TAB") 'copilot-accept-completion)
;;(define-key global-map (kbd "<tab>") #'copilot-tab)

;;
;;  Window Management
;;
(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(global-visual-line-mode 1)
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark)) ;; assuming you are using a dark theme
(add-to-list 'default-frame-alist '(height . 44))
(add-to-list 'default-frame-alist '(width . 120))
(setq inhibit-startup-screen t)

(setq ns-use-proxy-icon nil)
(setq frame-title-format nil)
(windmove-default-keybindings)

;;
;;  Backups and Autosave
;;
(setq backup-by-copying t  ; don't clobber symlinks
      backup-directory-alist
      '(("." . "~/.emacs.saves")) ; don't litter my fs tree
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t) ; use versioned backups

(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;;
;;  Default Tabs
;;
(setq-default indent-tabs-mode nil)
(setq tab-width 2)
(defvaralias 'c-basic-offset 'tab-width)
(defvaralias 'cperl-indent-level 'tab-width)
;;
;; Mouse Support
;;
(xterm-mouse-mode t)
(global-set-key [mouse-4] #'(lambda ()
                             (interactive)
                             (scroll-down 1)))
(global-set-key [mouse-5] #'(lambda ()
                             (interactive)
                             (scroll-up 1)))

(setq mouse-sel-mode t)
(setq scroll-step 1) ; smooth scrolling

(unless window-system
  (defun x-hide-tip ()
    (interactive)
    nil))

;;
;;  Line Numbers and Highlight
;;
(global-hl-todo-mode)
(add-hook 'prog-mode-hook 'highlight-symbol-mode)
(add-hook 'prog-mode-hook 'highlight-symbol-nav-mode)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;;
;;  Match Parens
;;
(show-paren-mode 1)
(set-face-background 'show-paren-match "DodgerBlue1")
(set-face-foreground 'show-paren-match "#def")
(set-face-attribute 'show-paren-match nil :weight 'extra-bold)

;;
;; Tramp
;;
(setq docker-tramp-use-names 1) ; tramp access docker container by name

;;
;; HideShow
;;
(global-set-key (kbd "C-c .") 'hs-show-block)
(global-set-key (kbd "C-c ,") 'hs-hide-block)
(global-set-key (kbd "C-c M-.") 'hs-show-all)
(global-set-key (kbd "C-c M-,") 'hs-hide-all)
(add-hook 'prog-mode-hook 'hs-minor-mode)

(provide 'ivy-ide)
;;; ivy-ide.el ends here
