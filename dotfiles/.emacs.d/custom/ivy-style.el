;;; ivy-style -- Ivy Witter's style configuration
;;; Commentary:
;; this is a configuration file
;;
;;; Code:

;; Line number formatting function
(defun linum-format-func (line)
  "Format line numbers for display."
  (let ((w (length (number-to-string (count-lines (point-min) (point-max))))))
    (propertize (format (format " %%%dd " w) line) 'face 'linum)))

(provide 'ivy-style)
;;; ivy-style.el ends here
