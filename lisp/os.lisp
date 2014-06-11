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
   (setf *icl-usrname* (icl-getenv icl-usrname-key))
   (setf *icl-hostname* (icl-getenv icl-hostname-key))
   (setf *icl-prompt* (if (equal *icl-usrname* "root")
                          #\#
                          #\$))))

(defun icl-getenv (name)
  "Get environment form OS such as linux/unix"
  (SB-UNIX::posix-getenv name))

(defun icl-shell (progname &optional (args nil))
  (let (retval)
    (setf retval (sb-ext:run-program progname
                                     (if (null args)
                                                  (list)
                                                  (list args))
                                     :output *standard-output*))
    (sb-ext:process-exit-code retval)))

(defun icl-do-directory (pathname func)
  "")

(defun icl-unit-test (program &optional (args nil))
  (if (null args)
      (format t "args is nil")
      (format t "args is not nil")))


