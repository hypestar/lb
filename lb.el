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
    (set-buffer (get-buffer-create "*DuggiDebug*")) 
    (erase-buffer)
    (nxml-mode)
    (mapcar (lambda (x)
	      (let 
		  ((name nil)
		   (info nil))
		(string-match "info=\"[[:alpha:] \| [:digit:] \| \s- \| _]*" x)
		(setq info (match-string 0 x))
		(string-match " name=\"[[:alpha:] \| [:digit:] \| // \| ( \| )]*" x)
		(setq name (match-string 0 x))
		(if (and name info)
		    (setq jd/lb-info-name-list (append jd/lb-info-name-list (list name info))))))
	    wrk-list)))



(defun jd/lb-test ()
  (interactive)
  (eval-buffer "lb.el")  
  (with-current-buffer "TBP.HTM.col.xml" (jd/lb-build-name-alist))
  )

(key-chord-define-global "vb" 'jd/lb-test)
(provide 'lb)
;;; lb.el ends here


