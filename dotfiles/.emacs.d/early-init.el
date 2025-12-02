;;; early-init.el --- Early initialization -*- lexical-binding: t -*-
;;; Commentary:
;; Emacs 27+ early initialization file
;; Loaded before GUI is initialized and before package system starts
;;
;;; Code:

;;
;; Performance optimizations
;;
(setq gc-cons-threshold most-positive-fixnum) ;; Maximize GC threshold during startup
(setq load-prefer-newer t) ;; Load newer compiled files

;;
;; GUI frame settings (set early to prevent flashing)
;;
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

;; macOS-specific frame settings
(when (featurep 'ns)
  (push '(ns-transparent-titlebar . t) default-frame-alist)
  (push '(ns-appearance . dark) default-frame-alist))

;;
;; Package system initialization
;;
(require 'package)

;; Configure package archives
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/") t)

;; Set archive priorities
(setq package-archive-priorities
      '(("melpa" . 10)
        ("gnu" . 5)))

;; Initialize package system
(package-initialize)

;; Enable use-package (built-in from Emacs 29+)
(require 'use-package)
(setq use-package-always-ensure t)  ;; Auto-install packages
(setq use-package-verbose t)        ;; Show loading times

;; Restore GC threshold after init
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 20 1024 1024)))) ;; 20MB

(provide 'early-init)
;;; early-init.el ends here
