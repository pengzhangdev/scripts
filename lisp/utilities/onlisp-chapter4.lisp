(proclaim '(inline last1 single append1 conc1 mklist)) ; set the simple function inline

(defun last1 (lst)
  "return the element of last list"
  (car (last lst)))

;; don't use (length) because we only check whether (cdr lst) is NULL
;; (length) will take long time if the lst not single
(defun single (lst)
  "check the lst contains single element"
  (and (consp lst) (not (cdr lst))))

(defun append1 (lst obj)
  "make a list for obj and append to lst"
  (append lst (list obj)))

(defun conc1 (obj)
  (nconc lst (list obj)))

(defun mklist (obj)
  "make a list if obj not a list"
  (if (listp obj) obj (list obj)))

;; Don't use (> (length x) (length y)), (length) will loop the x and y
(defun longer (x y)
  "check whether x is longer than y"
  (labels ((compare (x y)
             (and (consp x)
                  (or (null y)
                      (compare (cdr x) (cdr y))))))
    (if (and (listp x) (listp y))
        (compare x y)
        (> (length x) (length y)))))

(defun filter (fn lst)
  (let ((acc nil))
    (dolist (x lst)
      (let ((val (funcall fn x)))
        (if val (push val acc))))
    (nreverse acc)))

(defun group (source n)
  "split SOURCE into parts each contains N elements"
  (if (zerop n)
      (error "zero length")
      (labels ((rec (source acc)
                 (let ((rest (nthcdr n source)))
                   (if (consp rest)
                       (rec rest (cons (subseq source 0 n) acc))
                       (nreverse (cons source acc))))))
        (if (listp source)
            (rec source nil)
            nil))))
