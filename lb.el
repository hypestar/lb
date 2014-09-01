(require 's)



(defun jd/lb-buffer-is-col-xml ()
  "Determines wether the current buffer is visiting af file
which filename ends with .col.xml"
  (interactive)
  (setq jd/lb-filename (s-suffix? ".col.xml" (buffer-file-name))))




  ;;  <col seq="0" label="" info="Text" id=" " name="/(FUCKLB5ueA)" class="" width="" hId=" " hName=" " hDoc=" ">1</col>
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
	      (setq wrk-list (append wrk-list (list _line)))

	      ;;(message (last wrk-list 5))
	      ))

      	      
      ))
    (set-buffer (get-buffer-create "*DuggiDebug*")) 
    (erase-buffer)
    (nxml-mode)
;;    (insert (car wrk-list))
      (mapcar (lambda (x) 
		(insert x)		
		(newline)) wrk-list)))




(defun jd/lb-test ()
  (interactive)
  (eval-buffer "lb.el")  
  (with-current-buffer "TBP.HTM.col.xml" (jd/lb-build-name-alist))
  )

(key-chord-define-global "vb" 'jd/lb-test)


(provide 'lb)
;;; lb.el ends here


