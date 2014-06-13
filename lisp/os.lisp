(defpackage "ICL"
  (:nicknames "ICL")
  (:use "COMMON-LISP")
  (:export "icl-getenv"))

(defvar *icl-usrname*   "icl")
(defvar *icl-hostname*  "icl")
(defvar *icl-prompt*    "$")
(defvar *icl-path*      "")

(defconstant icl-usrname-key "USER")
(defconstant icl-hostname-key "HOSTNAME")

(defun icl-update-prompt-info ()
  "update *icl-usrname*  *icl-hostname* and *icl-prompt*"
  (values
   (setf *icl-usrname* (icl-getenv icl-usorname-key))
   (setf *icl-hostname* (icl-getenv icl-hostname-key))
   (setf *icl-prompt* (if (equal *icl-usrname* "root")
                          #\#
                          #\$))))

(defun icl-init-path (&optional (override t))
  "Update the var *icl-path* from Linux/Unix $PATH"
  (let ((str
         (icl-split-string #\: (icl-getenv "PATH"))))
    (if override
        (setf *icl-path* str)
        (setf *icl-path* (append str *icl-path*)))))

(defun icl-getenv (name)
  "Get environment form OS such as linux/unix"
  (SB-UNIX::posix-getenv name))

(defun icl-shell (progname &rest args)
  "run shell commands with args.
        if last args is stream , set the program output to stream"
  (let (proc-obj out-stream prog-args)
    (setf out-stream (car (reverse args)))
    (if (streamp out-stream)
        (setf prog-args (reverse (cdr (reverse args))))
        (progn
          (setf out-stream *standard-output*)
          (setf prog-args args)))
    (setf proc-obj (sb-ext:run-program progname prog-args
                                       :output out-stream))
    (sb-ext:process-exit-code proc-obj)))

(defun icl-split-string (sep str)
  "split string with split and return a list"
  (let ((result-list nil)
        (tmp-str str))
    (do ((pos (position sep tmp-str) (position sep tmp-str)))
        ((null pos) (append (list tmp-str) result-list))
      (if (equal pos 0)
          (setf tmp-str (subseq tmp-str (+ 1 pos)))
        (progn
          (setf result-list (append
                             (list (subseq tmp-str 0 pos))
                             result-list))
          (setf tmp-str (subseq tmp-str (+ 1 pos))))))))


(defun icl-do-directory (pathname func)
  "")


;;;; test 
(defun icl-unit-test (program &rest args)
  (if (null args)
      (format t "args is nil")
      (format t "~A ~%" (reverse args)))
  (let (out-stream prog-args)
    (setf out-stream (car (reverse args)))
    (if (streamp out-stream)
        (setf prog-args (reverse (cdr (reverse args))))
        (progn
          (setf out-stream *standard-output*)
          (setf prog-args args)))
    (format t "~A ~A ~%" out-stream prog-args)))
