
(cl:in-package :asdf)

(defsystem "idxpendant-srv"
  :depends-on (:roslisp-msg-protocol :roslisp-utils :idxpendant-msg
)
  :components ((:file "_package")
    (:file "SwitchesSrv" :depends-on ("_package_SwitchesSrv"))
    (:file "_package_SwitchesSrv" :depends-on ("_package"))
    (:file "SwitchSrv" :depends-on ("_package_SwitchSrv"))
    (:file "_package_SwitchSrv" :depends-on ("_package"))
  ))