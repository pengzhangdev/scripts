(defpackage #:cl-interaction
  (:nicknames #:ICL)
  (:use #:COMMON-LISP)
  (:export #:icl-getenv
           #:icl-shell
           #:icl-init-path))

(in-package #:ICL)

(defvar *icl-usrname*           "icl")
(defvar *icl-hostname*          "icl")
(defvar *icl-prompt*            "$")
(defvar *icl-path*              "")
(defvar *icl-working-directory*  (sb-posix:getcwd))

(defvar icl-usrname-key "USER")
(defvar icl-hostname-key "HOSTNAME")

(defmacro icl-log (formats &body args)
  "output the log message"
  `(format t ,formats ,@args))

(defun icl-getenv (name)
  "Get environment form OS such as linux/unix"
  (SB-UNIX::posix-getenv name))

(defun icl-split-string (sep str)
  "split string with seperator(multi) and return a list
   example: 
        \"-a b   c --d \"
   ===> (\"-a\" \"b\" \"c\" \"--d\")"
  (let ((result-list nil)
        (tmp-str str))
    (do ((pos (position sep tmp-str) (position sep tmp-str)))
        ((null pos) (reverse  (append (list tmp-str) result-list)))
      (if (equal pos 0)
          (setf tmp-str (subseq tmp-str (+ 1 pos)))
          (progn
            (setf result-list (append
                               (list (subseq tmp-str 0 pos))
                               result-list))
            (setf tmp-str (subseq tmp-str (+ 1 pos))))))))


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


(defun icl-update-prompt-info ()
  "update *icl-usrname*  *icl-hostname* and *icl-prompt*"
  (values
   (setf *icl-usrname* (icl-getenv icl-usrname-key))
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

(defun icl-shell (progname prog-args &key ((:input stream-in) 'stream) 
                                        ((:output stream-out) 'stream))
  "run shell commands with args.
        if last args is stream , set the program output to stream"
  (block func-shell
    (when (not (listp prog-args))
      (icl-log "args not a list ignore!")
      (return-from func-shell))
    (let ((prog-name progname)
          proc-obj in-stream out-stream)
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
      (if (null stream-out)
          (setf out-stream *standard-output*))
      (if (null stream-in)
          (setf in-stream nil))
      (setf proc-obj (sb-ext:run-program prog-name prog-args
                                         :input  in-stream
                                         :output out-stream))
      (sb-ext:process-exit-code proc-obj))))

(defun icl-cd (path)
  "change working directory to path"
  (sb-posix:chdir path)
  (setf *icl-working-directory* path))

;; (defun icl-ls (&optional args)
;;   "shell command ls implemented in clisp"
;;   )

(defun icl-getopt (args)
  "parse args as shell command getopt and return a list of results
  The args can be: -f  -b f --foo=bar \"foobar\"
  result ===> ((\"f\" . NIL) (\"b\" . \"f\") (\"foo\" . \"bar\") (NIL . \"foorbar\") NIL)"
  (block icl-getopt-stat
    (unless (stringp args)
      (icl-log "the args should be type string"))
    (let (arg-lst)
      (setf arg-lst (icl-split-string #\  args))  ;; split the args in list with seperator ' '
      (labels ((parse (arg-lst)
                 (if (null arg-lst)
                     nil
                     (let ((pos- (position #\- (car arg-lst)))
                           (token (car arg-lst)))
                       (if (null pos-)
                           (list (cons nil token) (parse (cdr arg-lst)))
                           (let ((pos= (position #\= token)))
                             (if (null pos=)
                                 (if (position #\- (car (cdr arg-lst)))
                                     (list (cons (remove #\- token) nil) 
                                           (parse (cdr arg-lst)))
                                     (list (cons (remove #\- token) 
                                                 (car (cdr arg-lst)))
                                           (parse (cdr (cdr arg-lst)))))
                                 (list (cons (remove #\- (subseq token 0 pos=))
                                             (subseq token (+ 1 pos=)))
                                       (parse (cdr arg-lst))))))))))
        (parse arg-lst)))))


;;;; test
;; (defun icl-unit-test (program &rest args)
;;   (if (null args)
;;       (format t "args is nil")
;;       (format t "~A ~%" (reverse args)))
;;   (let (prog-name out-stream prog-args)
;;     (setf out-stream (car (reverse args)))
;;     (setf prog-name program)
;;     (when (null (position #\/ prog-name))
;;       (format t "position nil")
;;       (setf prog-name (icl-maptest
;;                        #'(lambda (name path)
;;                            (let ((prog-name (concatenate 'string path "/" name)))
;;                              (if (probe-file prog-name)
;;                                  prog-name
;;                                  nil)))
;;                        prog-name *icl-path*)))
;;     ))
