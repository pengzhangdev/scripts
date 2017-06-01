(proclaim '(inline last1 single append1 conc1 mklist))

(defun last1 (lst)
  (car (last lst)))

(defun single (lst)
  ""
  (and (consp lst) (not (cdr lst))))
