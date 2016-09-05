
(cl:in-package :asdf)

(defsystem "idxpendant-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils )
  :components ((:file "_package")
    (:file "SwitchPos" :depends-on ("_package_SwitchPos"))
    (:file "_package_SwitchPos" :depends-on ("_package"))
  ))