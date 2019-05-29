;;; ivy-ide -- Ivy Witter's IDE configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:
(when (memq window-system '(mac ns x))
  (use-package exec-path-from-shell
    :ensure t
    :functions exec-path-from-shell-initialize
    :config
    (exec-path-from-shell-initialize)))

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

(defvar ns-use-proxy-icon)
(setq ns-use-proxy-icon nil)
(setq frame-title-format nil)
(global-set-key (kbd "C-c <up>") 'windmove-up)
(global-set-key (kbd "C-c <down>") 'windmove-down)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c <left>") 'windmove-left)
(use-package rotate :ensure t)

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
(use-package mouse
  :config
  (xterm-mouse-mode t)
  (global-set-key [mouse-4] '(lambda ()
                               (interactive)
                               (scroll-down 1)))
  (global-set-key [mouse-5] '(lambda ()
                               (interactive)
                               (scroll-up 1)))
  (defvar mouse-sel-mode)
  (setq mouse-sel-mode t)
  ;; smooth scrolling
  (setq scroll-step 1))

;;
;;  Line Numbers and Highlight
;;
(use-package hl-line :ensure t)

(use-package highlight-symbol
  :ensure t
  :hook ((prog-mode . highlight-symbol-mode)
         (prog-mode . highlight-symbol-nav-mode)))

(use-package minimap
 :ensure t
 :defer t
 :hook (minimap-sb-mode . (lambda () (setq mode-line-format nil))))

(use-package linum
  :ensure t
  :hook (prog-mode . linum-mode)
  :config
  (defvar linum-format)
  (defvar linum-disabled-modes-list)
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
  (setq linum-disabled-modes-list '(term-mode shell-mode eshell-mode wl-summary-mode compilation-mode custom-mode)))

;;
;;  Match Parens
;;
(use-package paren
  :ensure t
  :init
  (show-paren-mode 1)
  (set-face-background 'show-paren-match "color-237")
  (set-face-foreground 'show-paren-match "#def")
  (set-face-attribute 'show-paren-match nil :weight 'extra-bold))
;;
;; Tramp
;;
(use-package tramp
  :ensure t
  :config
  (setenv "ESHELL" "/bin/sh") ; fix shell
  (defvar docker-tramp-use-names)
  (setq docker-tramp-use-names 1) ; tramp access docker container by name
  (add-to-list 'tramp-default-proxies-alist
               '(nil "\\`root\\'" "/ssh:%h:"))
  (add-to-list 'tramp-default-proxies-alist
               '((regexp-quote (system-name)) nil nil)))

;;
;; HideShow
;;
(use-package hideshow
  :ensure t
  :bind
  (("C-c C-s" . hs-show-block)
   ("C-c C-h" . hs-hide-block)
   ("C-c C-M-h" . hs-hide-all)
   ("C-c C-M-s" . hs-show-all))
  :hook (prog-mode . hs-minor-mode))

;;
;;  Company Mode
;;
(use-package company
  :ensure t
  :init (global-company-mode)
  :config (setq company-minimum-prefix-length 2))

;;
;;  Fly Check
;;
(use-package flycheck
  :ensure t
  :config (global-flycheck-mode))

;;
;;  Prescient
;;
(use-package prescient
  :ensure t
  :config
  (prescient-persist-mode 1))

(use-package ivy-prescient
  :ensure t
  :config
  (ivy-prescient-mode 1))

(use-package company-prescient
  :ensure t
  :config
  (company-prescient-mode 1))


;;
;;  Ivy
;;
(use-package ivy
  :ensure t
  :config
  (ivy-mode 1))

;;
;;  Projectile
;;
(use-package projectile
  :ensure t
  :after ivy
  :bind-keymap ("C-c p". projectile-command-map)
  :functions projectile-register-project-type
  :defines projectile-completion-system
  :config
  (projectile-mode +1)
  (setq projectile-completion-system 'ivy)
  (projectile-register-project-type 'javascript '("package.json")
                                    :compile "npm install"
                                    :test "npm test"
                                    :run "npm start"
                                    :test-suffix ".spec"))

;;
;;  Ag Search
;;
(use-package ag
  :ensure t)

;;
;;  Magit
;;
(use-package magit :ensure t)

(provide 'ivy-ide)
;;; ivy-ide.el ends here
