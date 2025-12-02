;;; init.el --- Ivy Witter's Emacs configuration -*- lexical-binding: t -*-
;;; Commentary:
;; Main initialization file
;;
;;; Code:

;;
;; Custom settings file
;;
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;;
;; Helper function for mode-line
;;
(defun mode-check (mode-name)
  "Check to eval MODE-NAME if a cons."
  (if (consp mode-name)
      (capitalize (car mode-name))
    (capitalize mode-name)))

;;
;; Load custom configuration modules
;;
(add-to-list 'load-path (expand-file-name "custom" user-emacs-directory))

;; Core IDE and project settings
(require 'ivy-style)
(require 'ivy-ide)
(require 'ivy-project)

;; Version control
(require 'ivy-git)

;; Language-specific configurations
(require 'ivy-javascript)
(require 'ivy-typescript)
(require 'ivy-python)
(require 'ivy-rust)

;; Markup and data formats
(require 'ivy-web)
(require 'ivy-css)
(require 'ivy-text)
(require 'ivy-org)
(require 'ivy-configuration)
(require 'ivy-graphql)

;; Debugging
(require 'ivy-debug)

;;
;; Optional: Claude Code integration
;;
(let ((claude-code-path (expand-file-name "~/projects/claude-code-emacs")))
  (when (file-directory-p claude-code-path)
    (add-to-list 'load-path claude-code-path)
    (when (locate-library "claude-code")
      (require 'claude-code))))

;;
;; Flycheck configuration
;;
(setq-default flycheck-emacs-lisp-load-path load-path)

(provide 'init)
;;; init.el ends here
