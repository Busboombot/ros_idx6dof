;; Auto-generated. Do not edit!


(when (boundp 'arm::IKService)
  (if (not (find-package "ARM"))
    (make-package "ARM"))
  (shadow 'IKService (find-package "ARM")))
(unless (find-package "ARM::IKSERVICE")
  (make-package "ARM::IKSERVICE"))
(unless (find-package "ARM::IKSERVICEREQUEST")
  (make-package "ARM::IKSERVICEREQUEST"))
(unless (find-package "ARM::IKSERVICERESPONSE")
  (make-package "ARM::IKSERVICERESPONSE"))

(in-package "ROS")





(defclass arm::IKServiceRequest
  :super ros::object
  :slots (_target _currentPos ))

(defmethod arm::IKServiceRequest
  (:init
   (&key
    ((:target __target) (make-array 0 :initial-element 0.0 :element-type :float))
    ((:currentPos __currentPos) (make-array 0 :initial-element 0.0 :element-type :float))
    )
   (send-super :init)
   (setq _target __target)
   (setq _currentPos __currentPos)
   self)
  (:target
   (&optional __target)
   (if __target (setq _target __target)) _target)
  (:currentPos
   (&optional __currentPos)
   (if __currentPos (setq _currentPos __currentPos)) _currentPos)
  (:serialization-length
   ()
   (+
    ;; float32[] _target
    (* 4    (length _target)) 4
    ;; float32[] _currentPos
    (* 4    (length _currentPos)) 4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; float32[] _target
     (write-long (length _target) s)
     (dotimes (i (length _target))
       (sys::poke (elt _target i) (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
       )
     ;; float32[] _currentPos
     (write-long (length _currentPos) s)
     (dotimes (i (length _currentPos))
       (sys::poke (elt _currentPos i) (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
       )
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; float32[] _target
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _target (instantiate float-vector n))
     (dotimes (i n)
     (setf (elt _target i) (sys::peek buf ptr- :float)) (incf ptr- 4)
     ))
   ;; float32[] _currentPos
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _currentPos (instantiate float-vector n))
     (dotimes (i n)
     (setf (elt _currentPos i) (sys::peek buf ptr- :float)) (incf ptr- 4)
     ))
   ;;
   self)
  )

(defclass arm::IKServiceResponse
  :super ros::object
  :slots (_jointPos ))

(defmethod arm::IKServiceResponse
  (:init
   (&key
    ((:jointPos __jointPos) (make-array 0 :initial-element 0.0 :element-type :float))
    )
   (send-super :init)
   (setq _jointPos __jointPos)
   self)
  (:jointPos
   (&optional __jointPos)
   (if __jointPos (setq _jointPos __jointPos)) _jointPos)
  (:serialization-length
   ()
   (+
    ;; float32[] _jointPos
    (* 4    (length _jointPos)) 4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; float32[] _jointPos
     (write-long (length _jointPos) s)
     (dotimes (i (length _jointPos))
       (sys::poke (elt _jointPos i) (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
       )
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; float32[] _jointPos
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _jointPos (instantiate float-vector n))
     (dotimes (i n)
     (setf (elt _jointPos i) (sys::peek buf ptr- :float)) (incf ptr- 4)
     ))
   ;;
   self)
  )

(defclass arm::IKService
  :super ros::object
  :slots ())

(setf (get arm::IKService :md5sum-) "0811aef5e9050eb25cba782a9faf98fb")
(setf (get arm::IKService :datatype-) "arm/IKService")
(setf (get arm::IKService :request) arm::IKServiceRequest)
(setf (get arm::IKService :response) arm::IKServiceResponse)

(defmethod arm::IKServiceRequest
  (:response () (instance arm::IKServiceResponse :init)))

(setf (get arm::IKServiceRequest :md5sum-) "0811aef5e9050eb25cba782a9faf98fb")
(setf (get arm::IKServiceRequest :datatype-) "arm/IKServiceRequest")
(setf (get arm::IKServiceRequest :definition-)
      "float32[] target
float32[] currentPos
---
float32[] jointPos

")

(setf (get arm::IKServiceResponse :md5sum-) "0811aef5e9050eb25cba782a9faf98fb")
(setf (get arm::IKServiceResponse :datatype-) "arm/IKServiceResponse")
(setf (get arm::IKServiceResponse :definition-)
      "float32[] target
float32[] currentPos
---
float32[] jointPos

")



(provide :arm/IKService "0811aef5e9050eb25cba782a9faf98fb")


