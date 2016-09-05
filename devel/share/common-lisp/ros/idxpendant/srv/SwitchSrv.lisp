; Auto-generated. Do not edit!


(cl:in-package idxpendant-srv)


;//! \htmlinclude SwitchSrv-request.msg.html

(cl:defclass <SwitchSrv-request> (roslisp-msg-protocol:ros-message)
  ((switch_ref
    :reader switch_ref
    :initarg :switch_ref
    :type cl:string
    :initform ""))
)

(cl:defclass SwitchSrv-request (<SwitchSrv-request>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <SwitchSrv-request>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'SwitchSrv-request)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name idxpendant-srv:<SwitchSrv-request> is deprecated: use idxpendant-srv:SwitchSrv-request instead.")))

(cl:ensure-generic-function 'switch_ref-val :lambda-list '(m))
(cl:defmethod switch_ref-val ((m <SwitchSrv-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader idxpendant-srv:switch_ref-val is deprecated.  Use idxpendant-srv:switch_ref instead.")
  (switch_ref m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <SwitchSrv-request>) ostream)
  "Serializes a message object of type '<SwitchSrv-request>"
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'switch_ref))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'switch_ref))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <SwitchSrv-request>) istream)
  "Deserializes a message object of type '<SwitchSrv-request>"
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'switch_ref) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'switch_ref) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<SwitchSrv-request>)))
  "Returns string type for a service object of type '<SwitchSrv-request>"
  "idxpendant/SwitchSrvRequest")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'SwitchSrv-request)))
  "Returns string type for a service object of type 'SwitchSrv-request"
  "idxpendant/SwitchSrvRequest")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<SwitchSrv-request>)))
  "Returns md5sum for a message object of type '<SwitchSrv-request>"
  "ec07742aef364f2fbeeee9a3d0cc94bc")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'SwitchSrv-request)))
  "Returns md5sum for a message object of type 'SwitchSrv-request"
  "ec07742aef364f2fbeeee9a3d0cc94bc")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<SwitchSrv-request>)))
  "Returns full string definition for message of type '<SwitchSrv-request>"
  (cl:format cl:nil "string switch_ref~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'SwitchSrv-request)))
  "Returns full string definition for message of type 'SwitchSrv-request"
  (cl:format cl:nil "string switch_ref~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <SwitchSrv-request>))
  (cl:+ 0
     4 (cl:length (cl:slot-value msg 'switch_ref))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <SwitchSrv-request>))
  "Converts a ROS message object to a list"
  (cl:list 'SwitchSrv-request
    (cl:cons ':switch_ref (switch_ref msg))
))
;//! \htmlinclude SwitchSrv-response.msg.html

(cl:defclass <SwitchSrv-response> (roslisp-msg-protocol:ros-message)
  ((time
    :reader time
    :initarg :time
    :type cl:real
    :initform 0)
   (switch_no
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

(cl:defclass SwitchSrv-response (<SwitchSrv-response>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <SwitchSrv-response>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'SwitchSrv-response)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name idxpendant-srv:<SwitchSrv-response> is deprecated: use idxpendant-srv:SwitchSrv-response instead.")))

(cl:ensure-generic-function 'time-val :lambda-list '(m))
(cl:defmethod time-val ((m <SwitchSrv-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader idxpendant-srv:time-val is deprecated.  Use idxpendant-srv:time instead.")
  (time m))

(cl:ensure-generic-function 'switch_no-val :lambda-list '(m))
(cl:defmethod switch_no-val ((m <SwitchSrv-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader idxpendant-srv:switch_no-val is deprecated.  Use idxpendant-srv:switch_no instead.")
  (switch_no m))

(cl:ensure-generic-function 'switch_pos-val :lambda-list '(m))
(cl:defmethod switch_pos-val ((m <SwitchSrv-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader idxpendant-srv:switch_pos-val is deprecated.  Use idxpendant-srv:switch_pos instead.")
  (switch_pos m))

(cl:ensure-generic-function 'switch_name-val :lambda-list '(m))
(cl:defmethod switch_name-val ((m <SwitchSrv-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader idxpendant-srv:switch_name-val is deprecated.  Use idxpendant-srv:switch_name instead.")
  (switch_name m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <SwitchSrv-response>) ostream)
  "Serializes a message object of type '<SwitchSrv-response>"
  (cl:let ((__sec (cl:floor (cl:slot-value msg 'time)))
        (__nsec (cl:round (cl:* 1e9 (cl:- (cl:slot-value msg 'time) (cl:floor (cl:slot-value msg 'time)))))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __sec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __sec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __sec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __sec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 0) __nsec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __nsec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __nsec) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __nsec) ostream))
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'switch_no)) ostream)
  (cl:let* ((signed (cl:slot-value msg 'switch_pos)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 256) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    )
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'switch_name))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'switch_name))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <SwitchSrv-response>) istream)
  "Deserializes a message object of type '<SwitchSrv-response>"
    (cl:let ((__sec 0) (__nsec 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __sec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __sec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __sec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __sec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 0) __nsec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __nsec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __nsec) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __nsec) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'time) (cl:+ (cl:coerce __sec 'cl:double-float) (cl:/ __nsec 1e9))))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'switch_no)) (cl:read-byte istream))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'switch_pos) (cl:if (cl:< unsigned 128) unsigned (cl:- unsigned 256))))
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
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<SwitchSrv-response>)))
  "Returns string type for a service object of type '<SwitchSrv-response>"
  "idxpendant/SwitchSrvResponse")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'SwitchSrv-response)))
  "Returns string type for a service object of type 'SwitchSrv-response"
  "idxpendant/SwitchSrvResponse")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<SwitchSrv-response>)))
  "Returns md5sum for a message object of type '<SwitchSrv-response>"
  "ec07742aef364f2fbeeee9a3d0cc94bc")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'SwitchSrv-response)))
  "Returns md5sum for a message object of type 'SwitchSrv-response"
  "ec07742aef364f2fbeeee9a3d0cc94bc")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<SwitchSrv-response>)))
  "Returns full string definition for message of type '<SwitchSrv-response>"
  (cl:format cl:nil "time time~%uint8 switch_no~%int8 switch_pos~%string switch_name~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'SwitchSrv-response)))
  "Returns full string definition for message of type 'SwitchSrv-response"
  (cl:format cl:nil "time time~%uint8 switch_no~%int8 switch_pos~%string switch_name~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <SwitchSrv-response>))
  (cl:+ 0
     8
     1
     1
     4 (cl:length (cl:slot-value msg 'switch_name))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <SwitchSrv-response>))
  "Converts a ROS message object to a list"
  (cl:list 'SwitchSrv-response
    (cl:cons ':time (time msg))
    (cl:cons ':switch_no (switch_no msg))
    (cl:cons ':switch_pos (switch_pos msg))
    (cl:cons ':switch_name (switch_name msg))
))
(cl:defmethod roslisp-msg-protocol:service-request-type ((msg (cl:eql 'SwitchSrv)))
  'SwitchSrv-request)
(cl:defmethod roslisp-msg-protocol:service-response-type ((msg (cl:eql 'SwitchSrv)))
  'SwitchSrv-response)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'SwitchSrv)))
  "Returns string type for a service object of type '<SwitchSrv>"
  "idxpendant/SwitchSrv")