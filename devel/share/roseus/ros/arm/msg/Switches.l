;; Auto-generated. Do not edit!


(when (boundp 'arm::Switches)
  (if (not (find-package "ARM"))
    (make-package "ARM"))
  (shadow 'Switches (find-package "ARM")))
(unless (find-package "ARM::SWITCHES")
  (make-package "ARM::SWITCHES"))

(in-package "ROS")
;;//! \htmlinclude Switches.msg.html


(defclass arm::Switches
  :super ros::object
  :slots (_positions ))

(defmethod arm::Switches
  (:init
   (&key
    ((:positions __positions) (let (r) (dotimes (i 0) (push (instance arm::SwitchPos :init) r)) r))
    )
   (send-super :init)
   (setq _positions __positions)
   self)
  (:positions
   (&rest __positions)
   (if (keywordp (car __positions))
       (send* _positions __positions)
     (progn
       (if __positions (setq _positions (car __positions)))
       _positions)))
  (:serialization-length
   ()
   (+
    ;; arm/SwitchPos[] _positions
    (apply #'+ (send-all _positions :serialization-length)) 4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; arm/SwitchPos[] _positions
     (write-long (length _positions) s)
     (dolist (elem _positions)
       (send elem :serialize s)
       )
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; arm/SwitchPos[] _positions
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _positions (let (r) (dotimes (i n) (push (instance arm::SwitchPos :init) r)) r))
     (dolist (elem- _positions)
     (send elem- :deserialize buf ptr-) (incf ptr- (send elem- :serialization-length))
     ))
   ;;
   self)
  )

(setf (get arm::Switches :md5sum-) "72336361b4058bc9c050bf84bb606c9f")
(setf (get arm::Switches :datatype-) "arm/Switches")
(setf (get arm::Switches :definition-)
      "arm/SwitchPos[] positions

================================================================================
MSG: arm/SwitchPos
int8 UP=1
int8 NEUTRAL=0
int8 DOWN=-1
int8 pos

")



(provide :arm/Switches "72336361b4058bc9c050bf84bb606c9f")


