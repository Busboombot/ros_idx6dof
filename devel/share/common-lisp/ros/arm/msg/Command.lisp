; Auto-generated. Do not edit!


(cl:in-package arm-msg)


;//! \htmlinclude Command.msg.html

(cl:defclass <Command> (roslisp-msg-protocol:ros-message)
  ((switch_no
    :reader switch_no
    :initarg :switch_no
    :type cl:fixnum
    :initform 0)
   (switch_pos
    :reader switch_pos
    :initarg :switch_pos
    :type cl:fixnum
    :initform 0)
   (switch_name
    :reader switch_name
    :initarg :switch_name
    :type cl:string
    :initform ""))
)

(cl:defclass Command (<Command>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <Command>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'Command)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm-msg:<Command> is deprecated: use arm-msg:Command instead.")))

(cl:ensure-generic-function 'switch_no-val :lambda-list '(m))
(cl:defmethod switch_no-val ((m <Command>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm-msg:switch_no-val is deprecated.  Use arm-msg:switch_no instead.")
  (switch_no m))

(cl:ensure-generic-function 'switch_pos-val :lambda-list '(m))
(cl:defmethod switch_pos-val ((m <Command>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm-msg:switch_pos-val is deprecated.  Use arm-msg:switch_pos instead.")
  (switch_pos m))

(cl:ensure-generic-function 'switch_name-val :lambda-list '(m))
(cl:defmethod switch_name-val ((m <Command>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm-msg:switch_name-val is deprecated.  Use arm-msg:switch_name instead.")
  (switch_name m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <Command>) ostream)
  "Serializes a message object of type '<Command>"
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'switch_no)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'switch_pos)) ostream)
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'switch_name))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'switch_name))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <Command>) istream)
  "Deserializes a message object of type '<Command>"
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'switch_no)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'switch_pos)) (cl:read-byte istream))
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'switch_name) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'switch_name) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<Command>)))
  "Returns string type for a message object of type '<Command>"
  "arm/Command")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'Command)))
  "Returns string type for a message object of type 'Command"
  "arm/Command")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<Command>)))
  "Returns md5sum for a message object of type '<Command>"
  "ef707ea7563d7ccdfdd8bb776d91afd2")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'Command)))
  "Returns md5sum for a message object of type 'Command"
  "ef707ea7563d7ccdfdd8bb776d91afd2")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<Command>)))
  "Returns full string definition for message of type '<Command>"
  (cl:format cl:nil "uint8 switch_no~%uint8 switch_pos~%string switch_name~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'Command)))
  "Returns full string definition for message of type 'Command"
  (cl:format cl:nil "uint8 switch_no~%uint8 switch_pos~%string switch_name~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <Command>))
  (cl:+ 0
     1
     1
     4 (cl:length (cl:slot-value msg 'switch_name))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <Command>))
  "Converts a ROS message object to a list"
  (cl:list 'Command
    (cl:cons ':switch_no (switch_no msg))
    (cl:cons ':switch_pos (switch_pos msg))
    (cl:cons ':switch_name (switch_name msg))
))
