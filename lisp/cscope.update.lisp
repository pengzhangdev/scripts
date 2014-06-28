#! /usr/bin/sbcl --script

(require 'sb-posix)
(require 'sb-unix)
(require 'sb-ext)

(defvar *source-dirs* "")
(defvar *icl-path*    "")

;;;;;;;;;;;;;; main logic
(icl-init-path)



;;;;;;;;;;;;;; utilities 

(defmacro icl-log (formats &body args)
  "output the log message"
  `(format t ,formats ,@args))

(defun icl-init-path (&optional (override t))
  "Update the var *icl-path* from Linux/Unix $PATH"
  (let ((str
         (icl-split-string #\: (icl-getenv "PATH"))))
    (if override
        (setf *icl-path* str)
        (setf *icl-path* (append str *icl-path*)))))

(defun icl-shell (progname &rest args)
  "run shell commands with args.
        if last args is stream , set the program output to stream"
  (block func-shell
    (let ((out-stream (car (reverse args)))
          (prog-name progname)
          proc-obj prog-args)
      (when (null (position #\/ prog-name))
        ;;(format t "icl-path ~A" *icl-path*)
        (setf prog-name (icl-maptest
                         #'(lambda (name path)
                             (let ((prog-name (concatenate 'string path "/" name)))
                               (if (probe-file prog-name)
                                   prog-name
                                   nil)))
                         prog-name *icl-path*)))
      (when (null prog-name)
           (format t "Command ~A not found" progname)
           (return-from func-shell))
      (if (streamp out-stream)
          (setf prog-args (reverse (cdr (reverse args))))
          (progn
            (setf out-stream *standard-output*)
            (setf prog-args args)))
      (setf proc-obj (sb-ext:run-program prog-name prog-args
                                         :output out-stream
                                         :directory *icl-working-directory*))
      (sb-ext:process-exit-code proc-obj))))

(defun icl-maptest (func str lst)
  "operates on successive elements of the lists.
return first non-nil result"
  (block icl-maptest-stat
    (when (null lst)
      ;; (format t "lst is not found~%")
      (return-from icl-maptest-stat))
    (let (ret)
      (setf ret (funcall func str (car lst)))
      (if (null ret)
          (icl-maptest func str (cdr lst))
          ret))))
