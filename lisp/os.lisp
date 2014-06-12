(defpackage "ICL"
  (:nicknames "ICL")
  (:use "COMMON-LISP")
  (:export "icl-getenv"))

(defvar *icl-usrname*   "icl")
(defvar *icl-hostname*  "icl")
(defvar *icl-prompt*    "$")

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
