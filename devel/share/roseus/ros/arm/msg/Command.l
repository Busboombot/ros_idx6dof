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
  :slots (_switch_no _switch_pos _switch_name ))

(defmethod arm::Command
  (:init
   (&key
    ((:switch_no __switch_no) 0)
    ((:switch_pos __switch_pos) 0)
    ((:switch_name __switch_name) "")
    )
   (send-super :init)
   (setq _switch_no (round __switch_no))
   (setq _switch_pos (round __switch_pos))
   (setq _switch_name (string __switch_name))
   self)
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
    ;; uint8 _switch_no
    1
    ;; uint8 _switch_pos
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
     ;; uint8 _switch_pos
       (write-byte _switch_pos s)
     ;; string _switch_name
       (write-long (length _switch_name) s) (princ _switch_name s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; uint8 _switch_no
     (setq _switch_no (sys::peek buf ptr- :char)) (incf ptr- 1)
   ;; uint8 _switch_pos
     (setq _switch_pos (sys::peek buf ptr- :char)) (incf ptr- 1)
   ;; string _switch_name
     (let (n) (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4) (setq _switch_name (subseq buf ptr- (+ ptr- n))) (incf ptr- n))
   ;;
   self)
  )

(setf (get arm::Command :md5sum-) "ef707ea7563d7ccdfdd8bb776d91afd2")
(setf (get arm::Command :datatype-) "arm/Command")
(setf (get arm::Command :definition-)
      "uint8 switch_no
uint8 switch_pos
string switch_name
")



(provide :arm/Command "ef707ea7563d7ccdfdd8bb776d91afd2")


