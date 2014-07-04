#! /usr/bin/sbcl --script

(require 'sb-posix)
(require 'sb-unix)
(require 'sb-ext)

(load "icl/os.lisp")
(load "base64/package.lisp")
(load "base64/decode.lisp")
(load "base64/encode.lisp")

(defvar *samba-config*
  '(("/mnt/ftp_cos1" "//10.27.8.60/ftp" "MTk5MDAzMDU=" "d2VydGhlcnpoYW5n")
    ("/mnt/ftp_cos2" "//10.27.16.55/ftp" "MTk5MDAzMDU=" "d2VydGhlcnpoYW5n")
    ("/mnt/lt_share" "//10.27.254.202/LT-Share" "MTk5MDAzMDU=" "d2VydGhlcnpoYW5n")
    ("/mnt/Release" "//10.27.254.202/Release" "MTk5MDAzMDU=" "d2VydGhlcnpoYW5n")
    ("/mnt/fs" "//10.27.122.187/fs" "MTk5MDAzMDU=" "d2VydGhlcnpoYW5n")
    ("/mnt/win-source" "//10.27.254.202/Win-Source" "MTk5MDAzMDU=" "d2VydGhlcnpoYW5n"))
  "mount config for all mount point
   [mount_point] [mount_args] [passwd] [username]")

(defvar *sshfs-config*
  '(("/buildsvr_home" "werther@10.27.122.143:/home/werther/" "d2VydGhlcg==")
    ("/mnt/mail_dir" "root@10.27.8.121:/mnt" "MTIzNDU2"))
  "mount config for all mount point
   [mount_point] [svr_path] [passwd]")


;;;;;; main logic
;; (sb-ext:*posix-argv*)

(defmacro do-*-mount (type)
  "macro to return all kind of mount function
type should be samba/sshfs"
  `(defun ,(intern (concatenate 'string (symbol-name :do-)
                                (symbol-name type)
                                (symbol-name :-mount)))
       (config)
     "mount all filesystems"
     (unless (null config)
       (if (null (directory (nth 0 (car config))))
           (sb-posix:mkdir (nth 0 (car config)) 0755))
       (let ((passwd
              (cl-base64:base64-string-to-string
               (nth 2 (car config))))
             (prog-ret))
         ,@(case type
                 (:sshfs
                  '((setf prog-ret (icl:icl-shell "sshfs" (list
                                                            "-p 88"
                                                            (nth 1 (car config))
                                                            (nth 0 (car config))
                                                            "-o password_stdin")
                                     :input (make-string-input-stream passwd)))))
                 (:samba
                  '((let ((samba-usrname (make-string-output-stream))
                          (samba-passwd  (make-string-output-stream)))
                      (format samba-usrname "user=~A" (cl-base64:base64-string-to-string (nth 3 (car config))))
                      (format samba-passwd  "password=~A" passwd)
                      (setf prog-ret (icl:icl-shell "mount" (list
                                                             "-t cifs"
                                                             (nth 1 (car config))
                                                             (nth 0 (car config))
                                                             "-o"
                                                             (get-output-stream-string samba-usrname)
                                                             "-o"
                                                             (get-output-stream-string samba-passwd))))
                      ))))
         (if (eq prog-ret 0)
             (format t "mount ~A successfully ~%" (nth 0 (car config)))
             (format t "mount ~A failed (errno: ~A)~%" (nth 0 (car config)) prog-ret))
         )
       (,(intern (concatenate 'string (symbol-name :do-)
                              (symbol-name type)
                              (symbol-name :-mount))) (cdr config)))
     )
  )

(defmacro do-*-unmount (type)
  "macro to build unmount functions for all type"
  `(defun ,(intern (concatenate 'string 
                                (symbol-name :do-)
                                (symbol-name type)
                                (symbol-name :-unmount)))
       (config)
       "unmount all mount point"
       (unless (null config)
         (let (prog-ret)
           (setf prog-ret (icl:icl-shell "umount" (list
                                               (nth 0 (car config)))
                                     ))
           (if (eq prog-ret 0)
               (format t "umount ~A successfully ~%" (nth 0 (car config)))
               (format t "unmount ~A failed (errno: ~A)~%" (nth 0 (car config)) prog-ret)))
         (,(intern (concatenate 'string
                                (symbol-name :do-)
                                (symbol-name type)
                                (symbol-name :-unmount))) (cdr config)))))

(defun do-mount ()
  "search all mount config in *mount-config* and mount all"
  (icl:icl-init-path)
  (funcall (do-*-mount :samba) *samba-config*)
  (funcall (do-*-mount :sshfs) *sshfs-config*)
  )

(defun do-unmount ()
  "search all mount config in *mount-config* and unmount all"
  (icl:icl-init-path)
  (funcall (do-*-unmount :samba) *samba-config*)
  (funcall (do-*-unmount :sshfs) *sshfs-config*)
  )

(or
 (eq (car sb-ext:*posix-argv*) "mount")
 (eq (car sb-ext:*posix-argv*) "unmount")
 (format t "mount.lisp [mount/unmount]"))

(if (eq (car sb-ext:*posix-argv*) "mount")
    (do-mount))

(if (eq (car sb-ext:*posix-argv*) "unmount")
    (do-unmount))
