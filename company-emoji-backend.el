;;; company-emoji-backend.el -- company completion for emoji in emacs

;; Copyright (C) 2015 by Ross Donaldson

;; Package-Requires: ((dash "2.11.0") (emoji-cheat-sheet-plus "1.2.1) (company "0.9.0))
;;; Commentary:

;;; Code:

(require 'cl-lib)
(require 'dash)
(require 'company)
(require 'emoji-cheat-sheet-plus)

(defun ce/generate-candidates (to-match)
  ""
  (let ((names (-map 'first emoji-cheat-sheet-plus-image--cache))
        (matcher (lambda (s) (string-match-p (regexp-quote to-match) (symbol-name s)))))
    (-filter matcher names)))

(defun ce/backend (command &optional arg &rest ignored)
  "COMMAND ARG IGNORED Doc."
  (interactive (list 'interactive))
  (cl-case command
    (interactive (company-begin-backend 'ce/backend))
    (prefix (company-grab-symbol-cons ":"))
    (candidates (ce/generate-candidates arg))))

(provide 'company-emoji-backend)
;;; company-emoji-backend.el ends here
