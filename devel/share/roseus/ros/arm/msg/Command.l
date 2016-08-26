;; Auto-generated. Do not edit!


(when (boundp 'arm::Command)
  (if (not (find-package "ARM"))
    (make-package "ARM"))
  (shadow 'Command (find-package "ARM")))
(unless (find-package "ARM::COMMAND")
  (make-package "ARM::COMMAND"))

(in-package "ROS")
;;//! \htmlinclude Command.msg.html


(defclass arm::Command
  :super ros::object
  :slots (_cmd _params ))

(defmethod arm::Command
  (:init
   (&key
    ((:cmd __cmd) 0)
    ((:params __params) (make-array 0 :initial-element 0 :element-type :integer))
    )
   (send-super :init)
   (setq _cmd (round __cmd))
   (setq _params __params)
   self)
  (:cmd
   (&optional __cmd)
   (if __cmd (setq _cmd __cmd)) _cmd)
  (:params
   (&optional __params)
   (if __params (setq _params __params)) _params)
  (:serialization-length
   ()
   (+
    ;; uint8 _cmd
    1
    ;; int32[] _params
    (* 4    (length _params)) 4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; uint8 _cmd
       (write-byte _cmd s)
     ;; int32[] _params
     (write-long (length _params) s)
     (dotimes (i (length _params))
       (write-long (elt _params i) s)
       )
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; uint8 _cmd
     (setq _cmd (sys::peek buf ptr- :char)) (incf ptr- 1)
   ;; int32[] _params
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _params (instantiate integer-vector n))
     (dotimes (i n)
     (setf (elt _params i) (sys::peek buf ptr- :integer)) (incf ptr- 4)
     ))
   ;;
   self)
  )

(setf (get arm::Command :md5sum-) "ac224fe040657a122ab633b7a19a6e0a")
(setf (get arm::Command :datatype-) "arm/Command")
(setf (get arm::Command :definition-)
      "uint8 cmd
int32[] params


")



(provide :arm/Command "ac224fe040657a122ab633b7a19a6e0a")


