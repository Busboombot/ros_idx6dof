;; Auto-generated. Do not edit!


(when (boundp 'idxpendant::SwitchRequest)
  (if (not (find-package "IDXPENDANT"))
    (make-package "IDXPENDANT"))
  (shadow 'SwitchRequest (find-package "IDXPENDANT")))
(unless (find-package "IDXPENDANT::SWITCHREQUEST")
  (make-package "IDXPENDANT::SWITCHREQUEST"))
(unless (find-package "IDXPENDANT::SWITCHREQUESTREQUEST")
  (make-package "IDXPENDANT::SWITCHREQUESTREQUEST"))
(unless (find-package "IDXPENDANT::SWITCHREQUESTRESPONSE")
  (make-package "IDXPENDANT::SWITCHREQUESTRESPONSE"))

(in-package "ROS")





(defclass idxpendant::SwitchRequestRequest
  :super ros::object
  :slots (_switch_no _switch_name ))

(defmethod idxpendant::SwitchRequestRequest
  (:init
   (&key
    ((:switch_no __switch_no) 0)
    ((:switch_name __switch_name) "")
    )
   (send-super :init)
   (setq _switch_no (round __switch_no))
   (setq _switch_name (string __switch_name))
   self)
  (:switch_no
   (&optional __switch_no)
   (if __switch_no (setq _switch_no __switch_no)) _switch_no)
  (:switch_name
   (&optional __switch_name)
   (if __switch_name (setq _switch_name __switch_name)) _switch_name)
  (:serialization-length
   ()
   (+
    ;; uint8 _switch_no
    1
    ;; string _switch_name
    4 (length _switch_name)
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; uint8 _switch_no
       (write-byte _switch_no s)
     ;; string _switch_name
       (write-long (length _switch_name) s) (princ _switch_name s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; uint8 _switch_no
     (setq _switch_no (sys::peek buf ptr- :char)) (incf ptr- 1)
   ;; string _switch_name
     (let (n) (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4) (setq _switch_name (subseq buf ptr- (+ ptr- n))) (incf ptr- n))
   ;;
   self)
  )

(defclass idxpendant::SwitchRequestResponse
  :super ros::object
  :slots (_time _switch_no _switch_pos _switch_name ))

(defmethod idxpendant::SwitchRequestResponse
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

(defclass idxpendant::SwitchRequest
  :super ros::object
  :slots ())

(setf (get idxpendant::SwitchRequest :md5sum-) "12242c3da59534fae1a5eda4f02b556d")
(setf (get idxpendant::SwitchRequest :datatype-) "idxpendant/SwitchRequest")
(setf (get idxpendant::SwitchRequest :request) idxpendant::SwitchRequestRequest)
(setf (get idxpendant::SwitchRequest :response) idxpendant::SwitchRequestResponse)

(defmethod idxpendant::SwitchRequestRequest
  (:response () (instance idxpendant::SwitchRequestResponse :init)))

(setf (get idxpendant::SwitchRequestRequest :md5sum-) "12242c3da59534fae1a5eda4f02b556d")
(setf (get idxpendant::SwitchRequestRequest :datatype-) "idxpendant/SwitchRequestRequest")
(setf (get idxpendant::SwitchRequestRequest :definition-)
      "uint8 switch_no
string switch_name
---
time time
uint8 switch_no
int8 switch_pos
string switch_name
")

(setf (get idxpendant::SwitchRequestResponse :md5sum-) "12242c3da59534fae1a5eda4f02b556d")
(setf (get idxpendant::SwitchRequestResponse :datatype-) "idxpendant/SwitchRequestResponse")
(setf (get idxpendant::SwitchRequestResponse :definition-)
      "uint8 switch_no
string switch_name
---
time time
uint8 switch_no
int8 switch_pos
string switch_name
")



(provide :idxpendant/SwitchRequest "12242c3da59534fae1a5eda4f02b556d")


