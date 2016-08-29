; Auto-generated. Do not edit!


(cl:in-package arm-srv)


;//! \htmlinclude IKService-request.msg.html

(cl:defclass <IKService-request> (roslisp-msg-protocol:ros-message)
  ((target
    :reader target
    :initarg :target
    :type (cl:vector cl:float)
   :initform (cl:make-array 0 :element-type 'cl:float :initial-element 0.0))
   (currentPos
    :reader currentPos
    :initarg :currentPos
    :type (cl:vector cl:float)
   :initform (cl:make-array 0 :element-type 'cl:float :initial-element 0.0)))
)

(cl:defclass IKService-request (<IKService-request>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <IKService-request>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'IKService-request)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm-srv:<IKService-request> is deprecated: use arm-srv:IKService-request instead.")))

(cl:ensure-generic-function 'target-val :lambda-list '(m))
(cl:defmethod target-val ((m <IKService-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm-srv:target-val is deprecated.  Use arm-srv:target instead.")
  (target m))

(cl:ensure-generic-function 'currentPos-val :lambda-list '(m))
(cl:defmethod currentPos-val ((m <IKService-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm-srv:currentPos-val is deprecated.  Use arm-srv:currentPos instead.")
  (currentPos m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <IKService-request>) ostream)
  "Serializes a message object of type '<IKService-request>"
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'target))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (cl:let ((bits (roslisp-utils:encode-single-float-bits ele)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)))
   (cl:slot-value msg 'target))
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'currentPos))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (cl:let ((bits (roslisp-utils:encode-single-float-bits ele)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)))
   (cl:slot-value msg 'currentPos))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <IKService-request>) istream)
  "Deserializes a message object of type '<IKService-request>"
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'target) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'target)))
    (cl:dotimes (i __ros_arr_len)
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:aref vals i) (roslisp-utils:decode-single-float-bits bits))))))
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'currentPos) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'currentPos)))
    (cl:dotimes (i __ros_arr_len)
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:aref vals i) (roslisp-utils:decode-single-float-bits bits))))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<IKService-request>)))
  "Returns string type for a service object of type '<IKService-request>"
  "arm/IKServiceRequest")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'IKService-request)))
  "Returns string type for a service object of type 'IKService-request"
  "arm/IKServiceRequest")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<IKService-request>)))
  "Returns md5sum for a message object of type '<IKService-request>"
  "0811aef5e9050eb25cba782a9faf98fb")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'IKService-request)))
  "Returns md5sum for a message object of type 'IKService-request"
  "0811aef5e9050eb25cba782a9faf98fb")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<IKService-request>)))
  "Returns full string definition for message of type '<IKService-request>"
  (cl:format cl:nil "float32[] target~%float32[] currentPos~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'IKService-request)))
  "Returns full string definition for message of type 'IKService-request"
  (cl:format cl:nil "float32[] target~%float32[] currentPos~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <IKService-request>))
  (cl:+ 0
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'target) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 4)))
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'currentPos) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 4)))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <IKService-request>))
  "Converts a ROS message object to a list"
  (cl:list 'IKService-request
    (cl:cons ':target (target msg))
    (cl:cons ':currentPos (currentPos msg))
))
;//! \htmlinclude IKService-response.msg.html

(cl:defclass <IKService-response> (roslisp-msg-protocol:ros-message)
  ((jointPos
    :reader jointPos
    :initarg :jointPos
    :type (cl:vector cl:float)
   :initform (cl:make-array 0 :element-type 'cl:float :initial-element 0.0)))
)

(cl:defclass IKService-response (<IKService-response>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <IKService-response>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'IKService-response)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name arm-srv:<IKService-response> is deprecated: use arm-srv:IKService-response instead.")))

(cl:ensure-generic-function 'jointPos-val :lambda-list '(m))
(cl:defmethod jointPos-val ((m <IKService-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader arm-srv:jointPos-val is deprecated.  Use arm-srv:jointPos instead.")
  (jointPos m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <IKService-response>) ostream)
  "Serializes a message object of type '<IKService-response>"
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'jointPos))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (cl:let ((bits (roslisp-utils:encode-single-float-bits ele)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)))
   (cl:slot-value msg 'jointPos))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <IKService-response>) istream)
  "Deserializes a message object of type '<IKService-response>"
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'jointPos) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'jointPos)))
    (cl:dotimes (i __ros_arr_len)
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:aref vals i) (roslisp-utils:decode-single-float-bits bits))))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<IKService-response>)))
  "Returns string type for a service object of type '<IKService-response>"
  "arm/IKServiceResponse")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'IKService-response)))
  "Returns string type for a service object of type 'IKService-response"
  "arm/IKServiceResponse")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<IKService-response>)))
  "Returns md5sum for a message object of type '<IKService-response>"
  "0811aef5e9050eb25cba782a9faf98fb")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'IKService-response)))
  "Returns md5sum for a message object of type 'IKService-response"
  "0811aef5e9050eb25cba782a9faf98fb")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<IKService-response>)))
  "Returns full string definition for message of type '<IKService-response>"
  (cl:format cl:nil "float32[] jointPos~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'IKService-response)))
  "Returns full string definition for message of type 'IKService-response"
  (cl:format cl:nil "float32[] jointPos~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <IKService-response>))
  (cl:+ 0
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'jointPos) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 4)))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <IKService-response>))
  "Converts a ROS message object to a list"
  (cl:list 'IKService-response
    (cl:cons ':jointPos (jointPos msg))
))
(cl:defmethod roslisp-msg-protocol:service-request-type ((msg (cl:eql 'IKService)))
  'IKService-request)
(cl:defmethod roslisp-msg-protocol:service-response-type ((msg (cl:eql 'IKService)))
  'IKService-response)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'IKService)))
  "Returns string type for a service object of type '<IKService>"
  "arm/IKService")