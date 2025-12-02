;;; ivy-ide -- Ivy Witter's IDE configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:

(defvar ns-use-proxy-icon)
(defvar mouse-sel-mode)
(defvar docker-tramp-use-names)

;;
;; Utility packages
;;
(use-package xclip
  :config
  (xclip-mode 1))

(use-package rotate
  :defer t)

(use-package comment-tags
  :defer t)

(use-package highlight-symbol
  :hook ((prog-mode . highlight-symbol-mode)
         (prog-mode . highlight-symbol-nav-mode)))

;;
;;  Dialog Boxes
;;
(setq use-dialog-box nil)

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
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq mouse-wheel-progressive-speed nil)
(setq mouse-wheel-follow-mouse t)
(global-set-key [mouse-4] #'(lambda ()
                             (interactive)
                             (scroll-down 1)))
(global-set-key [mouse-5] #'(lambda ()
                             (interactive)
                             (scroll-up 1)))

(setq mouse-sel-mode t)
(setq scroll-step 1) ; smooth scrolling

;; Better mouse support in terminal
(unless window-system
  (require 'mouse)
  (xterm-mouse-mode t)
  (global-set-key [mouse-4] '(lambda () (interactive) (scroll-down 1)))
  (global-set-key [mouse-5] '(lambda () (interactive) (scroll-up 1))))

(unless window-system
  (defun x-hide-tip ()
    (interactive)
    nil))

;;
;;  Line Numbers and Highlight
;;
(use-package hl-todo
  :config
  (global-hl-todo-mode 1))

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
