
(cl:in-package :asdf)

(defsystem "arm-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils )
  :components ((:file "_package")
    (:file "Command" :depends-on ("_package_Command"))
    (:file "_package_Command" :depends-on ("_package"))
    (:file "SwitchPos" :depends-on ("_package_SwitchPos"))
    (:file "_package_SwitchPos" :depends-on ("_package"))
    (:file "Switches" :depends-on ("_package_Switches"))
    (:file "_package_Switches" :depends-on ("_package"))
  ))