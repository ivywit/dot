;;; phpactor-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "phpactor" "phpactor.el" (0 0 0 0))
;;; Generated autoloads from phpactor.el

(let ((loads (get 'phpactor 'custom-loads))) (if (member '"phpactor" loads) nil (put 'phpactor 'custom-loads (cons '"phpactor" loads))))

(defvar phpactor-install-directory (eval-when-compile (expand-file-name (locate-user-emacs-file "phpactor/"))) "\
Directory for setup Phactor.  (default `~/.emacs.d/phpactor/').")

(custom-autoload 'phpactor-install-directory "phpactor" t)

(autoload 'phpactor-smart-jump-register "phpactor" "\
Register `smart-jump' for MODES.

\(fn &optional MODES)" nil nil)

(autoload 'phpactor-install-or-update "phpactor" "\
Install or update phpactor inside phpactor.el's folder." t nil)

(autoload 'phpactor-open-rpc-documentation "phpactor" "\
Open the official documentation for COMMAND.

\(fn COMMAND)" t nil)

(autoload 'phpactor-copy-class "phpactor" "\
Execute Phpactor RPC copy_class command." t nil)

(autoload 'phpactor-move-class "phpactor" "\
Execute Phpactor RPC move_class command." t nil)

(autoload 'phpactor-offset-info "phpactor" "\
Execute Phpactor RPC offset_info command." t nil)

(autoload 'phpactor-transform "phpactor" "\
Execute Phpactor RPC transform command." t nil)

(autoload 'phpactor-context-menu "phpactor" "\
Execute Phpactor RPC context_menu command." t nil)

(autoload 'phpactor-navigate "phpactor" "\
Execute Phpactor RPC navigate command." t nil)

(autoload 'phpactor-extension-list "phpactor" "\
Execute Phpactor RPC extension_list command." t nil)

(autoload 'phpactor-extension-remove "phpactor" "\
Execute Phpactor RPC extension_remove command." t nil)

(autoload 'phpactor-extension-install "phpactor" "\
Execute Phpactor RPC extension_install command." t nil)

(autoload 'phpactor-echo "phpactor" "\
Execute Phpactor RPC echo command, say `MESSAGE'.

\(fn MESSAGE)" t nil)

(autoload 'phpactor-status "phpactor" "\
Execute Phpactor RPC status command, and pop to buffer." t nil)

(autoload 'phpactor-goto-definition "phpactor" "\
Execute Phpactor RPC goto_definition command." t nil)

(autoload 'phpactor-import-class "phpactor" "\
Execute Phpactor RPC import_class command for class NAME.

If called interactively, treat current symbol under cursor as NAME.
If any region is active, it takes precedence over symbol at point.

\(fn &optional NAME)" t nil)

(autoload 'phpactor-complete-constructor "phpactor" "\
Execute Phpactor RPC transform command to complete_constructor." t nil)

(autoload 'phpactor-rename-variable "phpactor" "\
Execute Phpactor RPC action to rename variable in SCOPE.

\(fn &optional SCOPE)" t nil)

(autoload 'phpactor-rename-variable-local "phpactor" "\
Execute Phpactor RPC action to rename variable locally." t nil)

(autoload 'phpactor-rename-variable-file "phpactor" "\
Execute Phpactor RPC action to rename variable in whole file." t nil)

(autoload 'phpactor-fix-namespace "phpactor" "\
Execute Phpactor RPC transform command to fix namespace." t nil)

(autoload 'phpactor-implement-contracts "phpactor" "\
Execute Phpactor RPC transform command to implement contracts." t nil)

(autoload 'phpactor-find-references "phpactor" "\
Execute Phpactor RPC references action to find references." t nil)

(autoload 'phpactor-replace-references "phpactor" "\
Execute Phpactor RPC references action command to replace references." t nil)

(autoload 'phpactor-file-information "phpactor" "\
Execute Phpactor RPC file_info command to gather file informations." t nil)

(autoload 'phpactor-insert-namespace "phpactor" "\
Find namespace for current file." t nil)

(autoload 'phpactor-generate-accessors "phpactor" "\
Execute Phpactor RPC generate_accessor action." t nil)

(autoload 'phpactor-generate-method "phpactor" "\
Execute Phpactor RPC generate_method action." t nil)

(autoload 'phpactor-add-missing-assignments "phpactor" "\
Execute Phpactor RPC add_missing_assignments action." t nil)

(autoload 'phpactor-create-new-class "phpactor" "\
Execute Phpactor RPC class_new action." t nil)

(autoload 'phpactor-inflect-class "phpactor" "\
Execute Phpactor RPC class_inflect action." t nil)

(autoload 'phpactor-extract-constant "phpactor" "\
Execute Phpactor RPC extract_constant action." t nil)

(autoload 'phpactor-hover "phpactor" "\
Execute Phpactor RPC hover action." t nil)

(autoload 'phpactor-extract-method "phpactor" "\
Execute Phpactor RPC extract_method action." t nil)

(autoload 'phpactor-extract-expression "phpactor" "\
Execute Phpactor RPC extract_expression action." t nil)

(autoload 'phpactor-change-visibility "phpactor" "\
Execute Phpactor RPC change_visibility action." t nil)

(autoload 'phpactor-override-method "phpactor" "\
Execute Phpactor RPC override_method action." t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "phpactor" '("phpactor-")))

;;;***

;;;### (autoloads nil nil ("phpactor-pkg.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; phpactor-autoloads.el ends here
