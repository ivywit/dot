;;; ivy-ide -- Ivy Witter's IDE configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:
(require 'mouse)
(require 'rotate)
(require 'hl-line)
(require 'hl-todo)
(require 'highlight-symbol)
(require 'linum)
(require 'paren)
(require 'tramp)
(require 'hideshow)
(when (memq window-system '(mac ns x))
  (require 'exec-path-from-shell)
  (exec-path-from-shell-initialize))

(defvar ns-use-proxy-icon)
(defvar mouse-sel-mode)
(defvar linum-format)
(defvar linum-disabled-modes-list)
(defvar docker-tramp-use-names)

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
(global-set-key (kbd "C-c <up>") 'windmove-up)
(global-set-key (kbd "C-c <down>") 'windmove-down)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c <left>") 'windmove-left)

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
(setq tab-width 4)
(defvaralias 'c-basic-offset 'tab-width)
(defvaralias 'cperl-indent-level 'tab-width)

;;
;; Mouse Support
;;
(xterm-mouse-mode t)
(global-set-key [mouse-4] '(lambda ()
                             (interactive)
                             (scroll-down 1)))
(global-set-key [mouse-5] '(lambda ()
                             (interactive)
                             (scroll-up 1)))

(setq mouse-sel-mode t)
(setq scroll-step 1) ; smooth scrolling


;;
;;  Line Numbers and Highlight
;;
(global-hl-todo-mode)
(add-hook 'prog-mode-hook 'highlight-symbol-mode)
(add-hook 'prog-mode-hook 'highlight-symbol-nav-mode)


(add-hook 'prog-mode-hook 'linum-mode)
(defun linum-format-func (line)
  "Format LINE numbers."
  (let ((w (length (number-to-string (count-lines (point-min) (point-max))))))
    (propertize (format (format "  %%%dd  " w) line) 'face 'linum)))
(defun linum-on ()
  "Enable linum mode."
  (unless (or (minibufferp) (member major-mode linum-disabled-modes-list))
    (linum-mode 1)))
;; format line numbers
(setq linum-format 'linum-format-func)
;; disable line numbers in certain modes
(setq linum-disabled-modes-list '(term-mode shell-mode eshell-mode wl-summary-mode compilation-mode custom-mode))

;;
;;  Match Parens
;;
(show-paren-mode 1)
(set-face-background 'show-paren-match "color-237")
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
