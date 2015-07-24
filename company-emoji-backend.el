;;; company-emoji-backend.el -- company completion for emoji in emacs

;; Copyright (C) 2015 by Ross Donaldson

;; Package-Requires: ((dash "2.11.0") (emoji-cheat-sheet-plus "1.2.1) (company "0.9.0))
;;; Commentary:

;;; Code:

(require 'cl-lib)
(require 'dash)
(require 'company)
(require 'emoji-cheat-sheet-plus)

(defun ce/load-emoji-names ()
  ""
  (if (eq (length emoji-cheat-sheet-plus-image--cache) 0)
      (emoji-cheat-sheet-plus--create-cache))
  (-map
   (lambda (ent) (substring (symbol-name (first ent)) 1 -1))
   emoji-cheat-sheet-plus-image--cache))

(defvar ce/emoji (ce/load-emoji-names))

(defun ce/generate-candidates (to-match)
  ""
  (let ((matcher (lambda (s) (string-match-p (regexp-quote to-match) s))))
    (-filter matcher ce/emoji)))

(defun company-emoji (command &optional arg &rest ignored)
  "COMMAND ARG IGNORED Doc."
  (interactive (list 'interactive))
  (cl-case command
    (interactive (company-begin-backend 'ce/backend))
    (prefix (company-grab-symbol-cons "^:"))
    (candidates (ce/generate-candidates arg))
    (no-cache t)
    (post-completion (insert ": "))))

;;;#autoload
(add-to-list 'company-backends 'company-emoji)

(provide 'company-emoji-backend)
;;; company-emoji-backend.el ends here
