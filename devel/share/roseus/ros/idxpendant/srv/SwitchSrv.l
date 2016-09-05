;; Auto-generated. Do not edit!


(when (boundp 'idxpendant::SwitchSrv)
  (if (not (find-package "IDXPENDANT"))
    (make-package "IDXPENDANT"))
  (shadow 'SwitchSrv (find-package "IDXPENDANT")))
(unless (find-package "IDXPENDANT::SWITCHSRV")
  (make-package "IDXPENDANT::SWITCHSRV"))
(unless (find-package "IDXPENDANT::SWITCHSRVREQUEST")
  (make-package "IDXPENDANT::SWITCHSRVREQUEST"))
(unless (find-package "IDXPENDANT::SWITCHSRVRESPONSE")
  (make-package "IDXPENDANT::SWITCHSRVRESPONSE"))

(in-package "ROS")





(defclass idxpendant::SwitchSrvRequest
  :super ros::object
  :slots (_switch_ref ))

(defmethod idxpendant::SwitchSrvRequest
  (:init
   (&key
    ((:switch_ref __switch_ref) "")
    )
   (send-super :init)
   (setq _switch_ref (string __switch_ref))
   self)
  (:switch_ref
   (&optional __switch_ref)
   (if __switch_ref (setq _switch_ref __switch_ref)) _switch_ref)
  (:serialization-length
   ()
   (+
    ;; string _switch_ref
    4 (length _switch_ref)
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; string _switch_ref
       (write-long (length _switch_ref) s) (princ _switch_ref s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; string _switch_ref
     (let (n) (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4) (setq _switch_ref (subseq buf ptr- (+ ptr- n))) (incf ptr- n))
   ;;
   self)
  )

(defclass idxpendant::SwitchSrvResponse
  :super ros::object
  :slots (_time _switch_no _switch_pos _switch_name ))

(defmethod idxpendant::SwitchSrvResponse
  (:init
   (&key
    ((:time __time) (instance ros::time :init))
    ((:switch_no __switch_no) 0)
    ((:switch_pos __switch_pos) 0)
    ((:switch_name __switch_name) "")
    )
   (send-super :init)
   (setq _time __time)
   (setq _switch_no (round __switch_no))
   (setq _switch_pos (round __switch_pos))
   (setq _switch_name (string __switch_name))
   self)
  (:time
   (&optional __time)
   (if __time (setq _time __time)) _time)
  (:switch_no
   (&optional __switch_no)
   (if __switch_no (setq _switch_no __switch_no)) _switch_no)
  (:switch_pos
   (&optional __switch_pos)
   (if __switch_pos (setq _switch_pos __switch_pos)) _switch_pos)
  (:switch_name
   (&optional __switch_name)
   (if __switch_name (setq _switch_name __switch_name)) _switch_name)
  (:serialization-length
   ()
   (+
    ;; time _time
    8
    ;; uint8 _switch_no
    1
    ;; int8 _switch_pos
    1
    ;; string _switch_name
    4 (length _switch_name)
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; time _time
       (write-long (send _time :sec) s) (write-long (send _time :nsec) s)
     ;; uint8 _switch_no
       (write-byte _switch_no s)
     ;; int8 _switch_pos
       (write-byte _switch_pos s)
     ;; string _switch_name
       (write-long (length _switch_name) s) (princ _switch_name s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; time _time
     (send _time :sec (sys::peek buf ptr- :integer)) (incf ptr- 4)  (send _time :nsec (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;; uint8 _switch_no
     (setq _switch_no (sys::peek buf ptr- :char)) (incf ptr- 1)
   ;; int8 _switch_pos
     (setq _switch_pos (sys::peek buf ptr- :char)) (incf ptr- 1)
     (if (> _switch_pos 127) (setq _switch_pos (- _switch_pos 256)))
   ;; string _switch_name
     (let (n) (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4) (setq _switch_name (subseq buf ptr- (+ ptr- n))) (incf ptr- n))
   ;;
   self)
  )

(defclass idxpendant::SwitchSrv
  :super ros::object
  :slots ())

(setf (get idxpendant::SwitchSrv :md5sum-) "ec07742aef364f2fbeeee9a3d0cc94bc")
(setf (get idxpendant::SwitchSrv :datatype-) "idxpendant/SwitchSrv")
(setf (get idxpendant::SwitchSrv :request) idxpendant::SwitchSrvRequest)
(setf (get idxpendant::SwitchSrv :response) idxpendant::SwitchSrvResponse)

(defmethod idxpendant::SwitchSrvRequest
  (:response () (instance idxpendant::SwitchSrvResponse :init)))

(setf (get idxpendant::SwitchSrvRequest :md5sum-) "ec07742aef364f2fbeeee9a3d0cc94bc")
(setf (get idxpendant::SwitchSrvRequest :datatype-) "idxpendant/SwitchSrvRequest")
(setf (get idxpendant::SwitchSrvRequest :definition-)
      "string switch_ref
---
time time
uint8 switch_no
int8 switch_pos
string switch_name
")

(setf (get idxpendant::SwitchSrvResponse :md5sum-) "ec07742aef364f2fbeeee9a3d0cc94bc")
(setf (get idxpendant::SwitchSrvResponse :datatype-) "idxpendant/SwitchSrvResponse")
(setf (get idxpendant::SwitchSrvResponse :definition-)
      "string switch_ref
---
time time
uint8 switch_no
int8 switch_pos
string switch_name
")



(provide :idxpendant/SwitchSrv "ec07742aef364f2fbeeee9a3d0cc94bc")


