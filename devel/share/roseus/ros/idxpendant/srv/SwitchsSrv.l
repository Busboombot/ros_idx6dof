;; Auto-generated. Do not edit!


(when (boundp 'idxpendant::SwitchsSrv)
  (if (not (find-package "IDXPENDANT"))
    (make-package "IDXPENDANT"))
  (shadow 'SwitchsSrv (find-package "IDXPENDANT")))
(unless (find-package "IDXPENDANT::SWITCHSSRV")
  (make-package "IDXPENDANT::SWITCHSSRV"))
(unless (find-package "IDXPENDANT::SWITCHSSRVREQUEST")
  (make-package "IDXPENDANT::SWITCHSSRVREQUEST"))
(unless (find-package "IDXPENDANT::SWITCHSSRVRESPONSE")
  (make-package "IDXPENDANT::SWITCHSSRVRESPONSE"))

(in-package "ROS")





(defclass idxpendant::SwitchsSrvRequest
  :super ros::object
  :slots ())

(defmethod idxpendant::SwitchsSrvRequest
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

(defclass idxpendant::SwitchsSrvResponse
  :super ros::object
  :slots (_switches ))

(defmethod idxpendant::SwitchsSrvResponse
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

(defclass idxpendant::SwitchsSrv
  :super ros::object
  :slots ())

(setf (get idxpendant::SwitchsSrv :md5sum-) "fdfeb5028b697838b970222e35ad759c")
(setf (get idxpendant::SwitchsSrv :datatype-) "idxpendant/SwitchsSrv")
(setf (get idxpendant::SwitchsSrv :request) idxpendant::SwitchsSrvRequest)
(setf (get idxpendant::SwitchsSrv :response) idxpendant::SwitchsSrvResponse)

(defmethod idxpendant::SwitchsSrvRequest
  (:response () (instance idxpendant::SwitchsSrvResponse :init)))

(setf (get idxpendant::SwitchsSrvRequest :md5sum-) "fdfeb5028b697838b970222e35ad759c")
(setf (get idxpendant::SwitchsSrvRequest :datatype-) "idxpendant/SwitchsSrvRequest")
(setf (get idxpendant::SwitchsSrvRequest :definition-)
      "
---
idxpendant/SwitchPos[] switches

================================================================================
MSG: idxpendant/SwitchPos

time time
uint8 switch_no
int8 switch_pos
")

(setf (get idxpendant::SwitchsSrvResponse :md5sum-) "fdfeb5028b697838b970222e35ad759c")
(setf (get idxpendant::SwitchsSrvResponse :datatype-) "idxpendant/SwitchsSrvResponse")
(setf (get idxpendant::SwitchsSrvResponse :definition-)
      "
---
idxpendant/SwitchPos[] switches

================================================================================
MSG: idxpendant/SwitchPos

time time
uint8 switch_no
int8 switch_pos
")



(provide :idxpendant/SwitchsSrv "fdfeb5028b697838b970222e35ad759c")


