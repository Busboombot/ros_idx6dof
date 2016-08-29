
(cl:in-package :asdf)

(defsystem "arm-srv"
  :depends-on (:roslisp-msg-protocol :roslisp-utils )
  :components ((:file "_package")
    (:file "IKService" :depends-on ("_package_IKService"))
    (:file "_package_IKService" :depends-on ("_package"))
  ))