; Auto-generated. Do not edit!


(cl:in-package idxpendant-srv)


;//! \htmlinclude SwitchsSrv-request.msg.html

(cl:defclass <SwitchsSrv-request> (roslisp-msg-protocol:ros-message)
  ()
)

(cl:defclass SwitchsSrv-request (<SwitchsSrv-request>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <SwitchsSrv-request>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'SwitchsSrv-request)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name idxpendant-srv:<SwitchsSrv-request> is deprecated: use idxpendant-srv:SwitchsSrv-request instead.")))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <SwitchsSrv-request>) ostream)
  "Serializes a message object of type '<SwitchsSrv-request>"
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <SwitchsSrv-request>) istream)
  "Deserializes a message object of type '<SwitchsSrv-request>"
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<SwitchsSrv-request>)))
  "Returns string type for a service object of type '<SwitchsSrv-request>"
  "idxpendant/SwitchsSrvRequest")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'SwitchsSrv-request)))
  "Returns string type for a service object of type 'SwitchsSrv-request"
  "idxpendant/SwitchsSrvRequest")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<SwitchsSrv-request>)))
  "Returns md5sum for a message object of type '<SwitchsSrv-request>"
  "fdfeb5028b697838b970222e35ad759c")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'SwitchsSrv-request)))
  "Returns md5sum for a message object of type 'SwitchsSrv-request"
  "fdfeb5028b697838b970222e35ad759c")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<SwitchsSrv-request>)))
  "Returns full string definition for message of type '<SwitchsSrv-request>"
  (cl:format cl:nil "~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'SwitchsSrv-request)))
  "Returns full string definition for message of type 'SwitchsSrv-request"
  (cl:format cl:nil "~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <SwitchsSrv-request>))
  (cl:+ 0
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <SwitchsSrv-request>))
  "Converts a ROS message object to a list"
  (cl:list 'SwitchsSrv-request
))
;//! \htmlinclude SwitchsSrv-response.msg.html

(cl:defclass <SwitchsSrv-response> (roslisp-msg-protocol:ros-message)
  ((switches
    :reader switches
    :initarg :switches
    :type (cl:vector idxpendant-msg:SwitchPos)
   :initform (cl:make-array 0 :element-type 'idxpendant-msg:SwitchPos :initial-element (cl:make-instance 'idxpendant-msg:SwitchPos))))
)

(cl:defclass SwitchsSrv-response (<SwitchsSrv-response>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <SwitchsSrv-response>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'SwitchsSrv-response)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name idxpendant-srv:<SwitchsSrv-response> is deprecated: use idxpendant-srv:SwitchsSrv-response instead.")))

(cl:ensure-generic-function 'switches-val :lambda-list '(m))
(cl:defmethod switches-val ((m <SwitchsSrv-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader idxpendant-srv:switches-val is deprecated.  Use idxpendant-srv:switches instead.")
  (switches m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <SwitchsSrv-response>) ostream)
  "Serializes a message object of type '<SwitchsSrv-response>"
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'switches))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (roslisp-msg-protocol:serialize ele ostream))
   (cl:slot-value msg 'switches))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <SwitchsSrv-response>) istream)
  "Deserializes a message object of type '<SwitchsSrv-response>"
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
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<SwitchsSrv-response>)))
  "Returns string type for a service object of type '<SwitchsSrv-response>"
  "idxpendant/SwitchsSrvResponse")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'SwitchsSrv-response)))
  "Returns string type for a service object of type 'SwitchsSrv-response"
  "idxpendant/SwitchsSrvResponse")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<SwitchsSrv-response>)))
  "Returns md5sum for a message object of type '<SwitchsSrv-response>"
  "fdfeb5028b697838b970222e35ad759c")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'SwitchsSrv-response)))
  "Returns md5sum for a message object of type 'SwitchsSrv-response"
  "fdfeb5028b697838b970222e35ad759c")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<SwitchsSrv-response>)))
  "Returns full string definition for message of type '<SwitchsSrv-response>"
  (cl:format cl:nil "idxpendant/SwitchPos[] switches~%~%================================================================================~%MSG: idxpendant/SwitchPos~%~%time time~%uint8 switch_no~%int8 switch_pos~%string switch_name~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'SwitchsSrv-response)))
  "Returns full string definition for message of type 'SwitchsSrv-response"
  (cl:format cl:nil "idxpendant/SwitchPos[] switches~%~%================================================================================~%MSG: idxpendant/SwitchPos~%~%time time~%uint8 switch_no~%int8 switch_pos~%string switch_name~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <SwitchsSrv-response>))
  (cl:+ 0
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'switches) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ (roslisp-msg-protocol:serialization-length ele))))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <SwitchsSrv-response>))
  "Converts a ROS message object to a list"
  (cl:list 'SwitchsSrv-response
    (cl:cons ':switches (switches msg))
))
(cl:defmethod roslisp-msg-protocol:service-request-type ((msg (cl:eql 'SwitchsSrv)))
  'SwitchsSrv-request)
(cl:defmethod roslisp-msg-protocol:service-response-type ((msg (cl:eql 'SwitchsSrv)))
  'SwitchsSrv-response)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'SwitchsSrv)))
  "Returns string type for a service object of type '<SwitchsSrv>"
  "idxpendant/SwitchsSrv")