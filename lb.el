(require 's)

(defvar jd/lb-info-name-list nil
"This list holds the implementation name and the friendly name of Plex objects"
)

(defun jd/lb-buffer-is-col-xml ()
  "Determines wether the current buffer is visiting af file
which filename ends with .col.xml"
  (interactive)
  (setq jd/lb-filename (s-suffix? ".col.xml" (buffer-file-name))))


  ;;  <col seq="0" label="" info="Text" id=" " name="/(LB5ueA)" class="" width="" hId=" " hName=" " hDoc=" ">1</col>
(defun jd/lb-build-name-alist ()
  (interactive)
  (let ((_line nil)
	(col-start 0)
	(col-end 0)	
	(wrk-list ()))
  (save-excursion 
    (goto-char (point-min))
    (while (and col-start col-end) 
      (setq col-start (search-forward-regexp "<col" nil t)) 
      (setq col-end (search-forward-regexp "</col>" nil t))
      (if (and col-start col-end)
	  (progn 
	      (setq _line (buffer-substring-no-properties col-start col-end))
	      (setq wrk-list (append wrk-list (list _line)))))))
    (mapcar 'jd/lb-extract-info-and-name wrk-list)))


(defun jd/lb-extract-info-and-name (col-tag-string)
  (let ((name nil)
	(info nil))
    (setq info (jd/lb-extract-info col-tag-string))
    (setq name (jd/lb-extract-name col-tag-string))
    (if (and name info)
	(setq jd/lb-info-name-list (append jd/lb-info-name-list (list name info))))))


(defun jd/lb-extract-info (col-tag-string)
  (string-match "info=\"[[:alpha:] \| [:digit:] \| \s- \| _]*" col-tag-string)
  (setq info (match-string 0 col-tag-string)))


(defun jd/lb-extract-name (col-tag-string)
  (string-match " name=\"[[:alpha:] \| [:digit:] \| // \| ( \| )]*" col-tag-string)
  (setq name (match-string 0 col-tag-string)))


(defun jd/lb-test ()
  (interactive)
  (eval-buffer "lb.el")  
  (with-current-buffer "TBP.HTM.col.xml" (jd/lb-build-name-alist))
)

(key-chord-define-global "vb" 'jd/lb-test)
(provide 'lb)
;;; lb.el ends here


