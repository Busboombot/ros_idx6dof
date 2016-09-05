; Auto-generated. Do not edit!


(cl:in-package idxpendant-srv)


;//! \htmlinclude SwitchesSrv-request.msg.html

(cl:defclass <SwitchesSrv-request> (roslisp-msg-protocol:ros-message)
  ()
)

(cl:defclass SwitchesSrv-request (<SwitchesSrv-request>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <SwitchesSrv-request>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'SwitchesSrv-request)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name idxpendant-srv:<SwitchesSrv-request> is deprecated: use idxpendant-srv:SwitchesSrv-request instead.")))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <SwitchesSrv-request>) ostream)
  "Serializes a message object of type '<SwitchesSrv-request>"
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <SwitchesSrv-request>) istream)
  "Deserializes a message object of type '<SwitchesSrv-request>"
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<SwitchesSrv-request>)))
  "Returns string type for a service object of type '<SwitchesSrv-request>"
  "idxpendant/SwitchesSrvRequest")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'SwitchesSrv-request)))
  "Returns string type for a service object of type 'SwitchesSrv-request"
  "idxpendant/SwitchesSrvRequest")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<SwitchesSrv-request>)))
  "Returns md5sum for a message object of type '<SwitchesSrv-request>"
  "fdfeb5028b697838b970222e35ad759c")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'SwitchesSrv-request)))
  "Returns md5sum for a message object of type 'SwitchesSrv-request"
  "fdfeb5028b697838b970222e35ad759c")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<SwitchesSrv-request>)))
  "Returns full string definition for message of type '<SwitchesSrv-request>"
  (cl:format cl:nil "~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'SwitchesSrv-request)))
  "Returns full string definition for message of type 'SwitchesSrv-request"
  (cl:format cl:nil "~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <SwitchesSrv-request>))
  (cl:+ 0
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <SwitchesSrv-request>))
  "Converts a ROS message object to a list"
  (cl:list 'SwitchesSrv-request
))
;//! \htmlinclude SwitchesSrv-response.msg.html

(cl:defclass <SwitchesSrv-response> (roslisp-msg-protocol:ros-message)
  ((switches
    :reader switches
    :initarg :switches
    :type (cl:vector idxpendant-msg:SwitchPos)
   :initform (cl:make-array 0 :element-type 'idxpendant-msg:SwitchPos :initial-element (cl:make-instance 'idxpendant-msg:SwitchPos))))
)

(cl:defclass SwitchesSrv-response (<SwitchesSrv-response>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <SwitchesSrv-response>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'SwitchesSrv-response)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name idxpendant-srv:<SwitchesSrv-response> is deprecated: use idxpendant-srv:SwitchesSrv-response instead.")))

(cl:ensure-generic-function 'switches-val :lambda-list '(m))
(cl:defmethod switches-val ((m <SwitchesSrv-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader idxpendant-srv:switches-val is deprecated.  Use idxpendant-srv:switches instead.")
  (switches m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <SwitchesSrv-response>) ostream)
  "Serializes a message object of type '<SwitchesSrv-response>"
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'switches))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (roslisp-msg-protocol:serialize ele ostream))
   (cl:slot-value msg 'switches))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <SwitchesSrv-response>) istream)
  "Deserializes a message object of type '<SwitchesSrv-response>"
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'switches) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'switches)))
    (cl:dotimes (i __ros_arr_len)
    (cl:setf (cl:aref vals i) (cl:make-instance 'idxpendant-msg:SwitchPos))
  (roslisp-msg-protocol:deserialize (cl:aref vals i) istream))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<SwitchesSrv-response>)))
  "Returns string type for a service object of type '<SwitchesSrv-response>"
  "idxpendant/SwitchesSrvResponse")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'SwitchesSrv-response)))
  "Returns string type for a service object of type 'SwitchesSrv-response"
  "idxpendant/SwitchesSrvResponse")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<SwitchesSrv-response>)))
  "Returns md5sum for a message object of type '<SwitchesSrv-response>"
  "fdfeb5028b697838b970222e35ad759c")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'SwitchesSrv-response)))
  "Returns md5sum for a message object of type 'SwitchesSrv-response"
  "fdfeb5028b697838b970222e35ad759c")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<SwitchesSrv-response>)))
  "Returns full string definition for message of type '<SwitchesSrv-response>"
  (cl:format cl:nil "idxpendant/SwitchPos[] switches~%~%================================================================================~%MSG: idxpendant/SwitchPos~%~%time time~%uint8 switch_no~%int8 switch_pos~%string switch_name~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'SwitchesSrv-response)))
  "Returns full string definition for message of type 'SwitchesSrv-response"
  (cl:format cl:nil "idxpendant/SwitchPos[] switches~%~%================================================================================~%MSG: idxpendant/SwitchPos~%~%time time~%uint8 switch_no~%int8 switch_pos~%string switch_name~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <SwitchesSrv-response>))
  (cl:+ 0
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'switches) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ (roslisp-msg-protocol:serialization-length ele))))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <SwitchesSrv-response>))
  "Converts a ROS message object to a list"
  (cl:list 'SwitchesSrv-response
    (cl:cons ':switches (switches msg))
))
(cl:defmethod roslisp-msg-protocol:service-request-type ((msg (cl:eql 'SwitchesSrv)))
  'SwitchesSrv-request)
(cl:defmethod roslisp-msg-protocol:service-response-type ((msg (cl:eql 'SwitchesSrv)))
  'SwitchesSrv-response)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'SwitchesSrv)))
  "Returns string type for a service object of type '<SwitchesSrv>"
  "idxpendant/SwitchesSrv")