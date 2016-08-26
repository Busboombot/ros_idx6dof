; Auto-generated. Do not edit!


(cl:in-package arm-msg)


;//! \htmlinclude Switches.msg.html

(cl:defclass <Switches> (roslisp-msg-protocol:ros-message)
  ((positions
    :reader positions
    :initarg :positions
    :type (cl:vector arm-msg:SwitchPos)
   :initform (cl:make-array 0 :element-type 'arm-msg:SwitchPos :initial-element (cl:make-instance 'arm-msg:SwitchPos))))
)

(cl:defclass Switches (<Switches>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <Switches>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'Switches)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm-msg:<Switches> is deprecated: use arm-msg:Switches instead.")))

(cl:ensure-generic-function 'positions-val :lambda-list '(m))
(cl:defmethod positions-val ((m <Switches>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm-msg:positions-val is deprecated.  Use arm-msg:positions instead.")
  (positions m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <Switches>) ostream)
  "Serializes a message object of type '<Switches>"
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'positions))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (roslisp-msg-protocol:serialize ele ostream))
   (cl:slot-value msg 'positions))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <Switches>) istream)
  "Deserializes a message object of type '<Switches>"
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'positions) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'positions)))
    (cl:dotimes (i __ros_arr_len)
    (cl:setf (cl:aref vals i) (cl:make-instance 'arm-msg:SwitchPos))
  (roslisp-msg-protocol:deserialize (cl:aref vals i) istream))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<Switches>)))
  "Returns string type for a message object of type '<Switches>"
  "arm/Switches")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'Switches)))
  "Returns string type for a message object of type 'Switches"
  "arm/Switches")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<Switches>)))
  "Returns md5sum for a message object of type '<Switches>"
  "72336361b4058bc9c050bf84bb606c9f")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'Switches)))
  "Returns md5sum for a message object of type 'Switches"
  "72336361b4058bc9c050bf84bb606c9f")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<Switches>)))
  "Returns full string definition for message of type '<Switches>"
  (cl:format cl:nil "arm/SwitchPos[] positions~%~%================================================================================~%MSG: arm/SwitchPos~%int8 UP=1~%int8 NEUTRAL=0~%int8 DOWN=-1~%int8 pos~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'Switches)))
  "Returns full string definition for message of type 'Switches"
  (cl:format cl:nil "arm/SwitchPos[] positions~%~%================================================================================~%MSG: arm/SwitchPos~%int8 UP=1~%int8 NEUTRAL=0~%int8 DOWN=-1~%int8 pos~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <Switches>))
  (cl:+ 0
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'positions) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ (roslisp-msg-protocol:serialization-length ele))))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <Switches>))
  "Converts a ROS message object to a list"
  (cl:list 'Switches
    (cl:cons ':positions (positions msg))
))
