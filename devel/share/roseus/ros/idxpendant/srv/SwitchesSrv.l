;; Auto-generated. Do not edit!


(when (boundp 'idxpendant::SwitchesSrv)
  (if (not (find-package "IDXPENDANT"))
    (make-package "IDXPENDANT"))
  (shadow 'SwitchesSrv (find-package "IDXPENDANT")))
(unless (find-package "IDXPENDANT::SWITCHESSRV")
  (make-package "IDXPENDANT::SWITCHESSRV"))
(unless (find-package "IDXPENDANT::SWITCHESSRVREQUEST")
  (make-package "IDXPENDANT::SWITCHESSRVREQUEST"))
(unless (find-package "IDXPENDANT::SWITCHESSRVRESPONSE")
  (make-package "IDXPENDANT::SWITCHESSRVRESPONSE"))

(in-package "ROS")





(defclass idxpendant::SwitchesSrvRequest
  :super ros::object
  :slots ())

(defmethod idxpendant::SwitchesSrvRequest
  (:init
   (&key
    )
   (send-super :init)
   self)
  (:serialization-length
   ()
   (+
    0
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;;
   self)
  )

(defclass idxpendant::SwitchesSrvResponse
  :super ros::object
  :slots (_switches ))

(defmethod idxpendant::SwitchesSrvResponse
  (:init
   (&key
    ((:switches __switches) (let (r) (dotimes (i 0) (push (instance idxpendant::SwitchPos :init) r)) r))
    )
   (send-super :init)
   (setq _switches __switches)
   self)
  (:switches
   (&rest __switches)
   (if (keywordp (car __switches))
       (send* _switches __switches)
     (progn
       (if __switches (setq _switches (car __switches)))
       _switches)))
  (:serialization-length
   ()
   (+
    ;; idxpendant/SwitchPos[] _switches
    (apply #'+ (send-all _switches :serialization-length)) 4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; idxpendant/SwitchPos[] _switches
     (write-long (length _switches) s)
     (dolist (elem _switches)
       (send elem :serialize s)
       )
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; idxpendant/SwitchPos[] _switches
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _switches (let (r) (dotimes (i n) (push (instance idxpendant::SwitchPos :init) r)) r))
     (dolist (elem- _switches)
     (send elem- :deserialize buf ptr-) (incf ptr- (send elem- :serialization-length))
     ))
   ;;
   self)
  )

(defclass idxpendant::SwitchesSrv
  :super ros::object
  :slots ())

(setf (get idxpendant::SwitchesSrv :md5sum-) "fdfeb5028b697838b970222e35ad759c")
(setf (get idxpendant::SwitchesSrv :datatype-) "idxpendant/SwitchesSrv")
(setf (get idxpendant::SwitchesSrv :request) idxpendant::SwitchesSrvRequest)
(setf (get idxpendant::SwitchesSrv :response) idxpendant::SwitchesSrvResponse)

(defmethod idxpendant::SwitchesSrvRequest
  (:response () (instance idxpendant::SwitchesSrvResponse :init)))

(setf (get idxpendant::SwitchesSrvRequest :md5sum-) "fdfeb5028b697838b970222e35ad759c")
(setf (get idxpendant::SwitchesSrvRequest :datatype-) "idxpendant/SwitchesSrvRequest")
(setf (get idxpendant::SwitchesSrvRequest :definition-)
      "
---
idxpendant/SwitchPos[] switches

================================================================================
MSG: idxpendant/SwitchPos

time time
uint8 switch_no
int8 switch_pos
")

(setf (get idxpendant::SwitchesSrvResponse :md5sum-) "fdfeb5028b697838b970222e35ad759c")
(setf (get idxpendant::SwitchesSrvResponse :datatype-) "idxpendant/SwitchesSrvResponse")
(setf (get idxpendant::SwitchesSrvResponse :definition-)
      "
---
idxpendant/SwitchPos[] switches

================================================================================
MSG: idxpendant/SwitchPos

time time
uint8 switch_no
int8 switch_pos
")



(provide :idxpendant/SwitchesSrv "fdfeb5028b697838b970222e35ad759c")


