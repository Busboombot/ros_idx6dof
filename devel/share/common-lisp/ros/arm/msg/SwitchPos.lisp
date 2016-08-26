; Auto-generated. Do not edit!


(cl:in-package arm-msg)


;//! \htmlinclude SwitchPos.msg.html

(cl:defclass <SwitchPos> (roslisp-msg-protocol:ros-message)
  ((pos
    :reader pos
    :initarg :pos
    :type cl:fixnum
    :initform 0))
)

(cl:defclass SwitchPos (<SwitchPos>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <SwitchPos>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'SwitchPos)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm-msg:<SwitchPos> is deprecated: use arm-msg:SwitchPos instead.")))

(cl:ensure-generic-function 'pos-val :lambda-list '(m))
(cl:defmethod pos-val ((m <SwitchPos>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm-msg:pos-val is deprecated.  Use arm-msg:pos instead.")
  (pos m))
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql '<SwitchPos>)))
    "Constants for message type '<SwitchPos>"
  '((:UP . 1)
    (:NEUTRAL . 0)
    (:DOWN . -1))
)
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql 'SwitchPos)))
    "Constants for message type 'SwitchPos"
  '((:UP . 1)
    (:NEUTRAL . 0)
    (:DOWN . -1))
)
(cl:defmethod roslisp-msg-protocol:serialize ((msg <SwitchPos>) ostream)
  "Serializes a message object of type '<SwitchPos>"
  (cl:let* ((signed (cl:slot-value msg 'pos)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 256) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    )
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <SwitchPos>) istream)
  "Deserializes a message object of type '<SwitchPos>"
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'pos) (cl:if (cl:< unsigned 128) unsigned (cl:- unsigned 256))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<SwitchPos>)))
  "Returns string type for a message object of type '<SwitchPos>"
  "arm/SwitchPos")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'SwitchPos)))
  "Returns string type for a message object of type 'SwitchPos"
  "arm/SwitchPos")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<SwitchPos>)))
  "Returns md5sum for a message object of type '<SwitchPos>"
  "618967a4b6ca1e2301a98e484144452b")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'SwitchPos)))
  "Returns md5sum for a message object of type 'SwitchPos"
  "618967a4b6ca1e2301a98e484144452b")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<SwitchPos>)))
  "Returns full string definition for message of type '<SwitchPos>"
  (cl:format cl:nil "int8 UP=1~%int8 NEUTRAL=0~%int8 DOWN=-1~%int8 pos~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'SwitchPos)))
  "Returns full string definition for message of type 'SwitchPos"
  (cl:format cl:nil "int8 UP=1~%int8 NEUTRAL=0~%int8 DOWN=-1~%int8 pos~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <SwitchPos>))
  (cl:+ 0
     1
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <SwitchPos>))
  "Converts a ROS message object to a list"
  (cl:list 'SwitchPos
    (cl:cons ':pos (pos msg))
))
