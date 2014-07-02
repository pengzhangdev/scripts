#! /usr/bin/sbcl --script

(require 'sb-posix)
(require 'sb-unix)
(require 'sb-ext)

(load "icl/os.lisp")
(load "base64/package.lisp")
(load "base64/decode.lisp")
(load "base64/encode.lisp")

(defparameter *samba-config*
  '(("/mnt/ftp_cos1" "//10.27.8.60/ftp" "MTk5MDAwMzA1Cg==")
    ("/mnt/ftp_cos2" "//10.27.16.55/ftp" "MTk5MDAwMzA1Cg==")
    ("/mnt/lt_share" "//10.27.254.202/LT-Share" "MTk5MDAwMzA1Cg==")
    ("/mnt/Release" "//10.27.254.202/Release" "MTk5MDAwMzA1Cg==")
    ("/mnt/fs" "//10.27.122.187/fs" "MTk5MDAwMzA1Cg==")
    ("/mnt/win-source" "//10.27.254.202/Win-Source" "MTk5MDAwMzA1Cg=="))
  "mount config for all mount point
   [mount_point] [mount_args] [passwd]")

(defparameter *sshfs-config*
  '(("/buildsvr_home" "werther@10.27.122.143:/home/werther/" "d2VydGhlcgo=")
    ("/mnt/mail_dir" "root@10.27.8.121:/mnt" "MTIzNDU2Cg=="))
  "mount config for all mount point
   [mount_point] [svr_path] [passwd]")


;;;;;; main logic
;; (sb-ext:*posix-argv*)

(defmacro do-*-mount (type)
  "macro to return all kind of mount function
type should be samba/sshfs"
  `(defun ,(intern (concatenate 'string "do-"
                                (symbol-name type)
                                "-mount"))
       (config)
     "mount all filesystems"
     (if (null (directory (nth 0 (car config))))
         (sb-posix:mkdir (nth 0 (car config)) 0755))
     (let ((passwd 
            (cl-base64:base64-string-to-string 
             (nth 2 (car config)))))
       
       )
     )
  )

(defun do-mount ()
  "search all mount config in *mount-config* and mount all"
  (funcall (do-*-mount 'samba) *samba-config*)
  (funcall (do-*mount 'sshfs) *sshfs-config*)
  )

(defun do-unmount ()
  "search all mount config in *mount-config* and unmount all"
  )

(or
 (eq (car sb-ext:*posix-argv*) "mount")
 (eq (car sb-ext:*posix-argv*) "unmount")
 (format t "mount.lisp [mount/unmount]"))

(if (eq (car sb-ext:*posix-argv*) "mount")
    (do-mount))

(if (eq (car sb-ext:*posix-argv*) "unmount")
    (do-unmount))
