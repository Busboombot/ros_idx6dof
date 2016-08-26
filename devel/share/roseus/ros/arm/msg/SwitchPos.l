;; Auto-generated. Do not edit!


(when (boundp 'arm::SwitchPos)
  (if (not (find-package "ARM"))
    (make-package "ARM"))
  (shadow 'SwitchPos (find-package "ARM")))
(unless (find-package "ARM::SWITCHPOS")
  (make-package "ARM::SWITCHPOS"))

(in-package "ROS")
;;//! \htmlinclude SwitchPos.msg.html


(intern "*UP*" (find-package "ARM::SWITCHPOS"))
(shadow '*UP* (find-package "ARM::SWITCHPOS"))
(defconstant arm::SwitchPos::*UP* 1)
(intern "*NEUTRAL*" (find-package "ARM::SWITCHPOS"))
(shadow '*NEUTRAL* (find-package "ARM::SWITCHPOS"))
(defconstant arm::SwitchPos::*NEUTRAL* 0)
(intern "*DOWN*" (find-package "ARM::SWITCHPOS"))
(shadow '*DOWN* (find-package "ARM::SWITCHPOS"))
(defconstant arm::SwitchPos::*DOWN* -1)
(defclass arm::SwitchPos
  :super ros::object
  :slots (_pos ))

(defmethod arm::SwitchPos
  (:init
   (&key
    ((:pos __pos) 0)
    )
   (send-super :init)
   (setq _pos (round __pos))
   self)
  (:pos
   (&optional __pos)
   (if __pos (setq _pos __pos)) _pos)
  (:serialization-length
   ()
   (+
    ;; int8 _pos
    1
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; int8 _pos
       (write-byte _pos s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; int8 _pos
     (setq _pos (sys::peek buf ptr- :char)) (incf ptr- 1)
     (if (> _pos 127) (setq _pos (- _pos 256)))
   ;;
   self)
  )

(setf (get arm::SwitchPos :md5sum-) "618967a4b6ca1e2301a98e484144452b")
(setf (get arm::SwitchPos :datatype-) "arm/SwitchPos")
(setf (get arm::SwitchPos :definition-)
      "int8 UP=1
int8 NEUTRAL=0
int8 DOWN=-1
int8 pos

")



(provide :arm/SwitchPos "618967a4b6ca1e2301a98e484144452b")


