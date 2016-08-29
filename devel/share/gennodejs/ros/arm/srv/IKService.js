// Auto-generated. Do not edit!

// (in-package arm.srv)


"use strict";

let _serializer = require('../base_serialize.js');
let _deserializer = require('../base_deserialize.js');
let _finder = require('../find.js');

//-----------------------------------------------------------


//-----------------------------------------------------------

class IKServiceRequest {
  constructor() {
    this.target = [];
    this.currentPos = [];
  }

  static serialize(obj, bufferInfo) {
    // Serializes a message object of type IKServiceRequest
    // Serialize the length for message field [target]
    bufferInfo = _serializer.uint32(obj.target.length, bufferInfo);
    // Serialize message field [target]
    obj.target.forEach((val) => {
      bufferInfo = _serializer.float32(val, bufferInfo);
    });
    // Serialize the length for message field [currentPos]
    bufferInfo = _serializer.uint32(obj.currentPos.length, bufferInfo);
    // Serialize message field [currentPos]
    obj.currentPos.forEach((val) => {
      bufferInfo = _serializer.float32(val, bufferInfo);
    });
    return bufferInfo;
  }

  static deserialize(buffer) {
    //deserializes a message object of type IKServiceRequest
    let tmp;
    let len;
    let data = new IKServiceRequest();
    // Deserialize array length for message field [target]
    tmp = _deserializer.uint32(buffer);
    len = tmp.data;
    buffer = tmp.buffer;
    // Deserialize message field [target]
    data.target = new Array(len);
    for (let i = 0; i < len; ++i) {
      tmp = _deserializer.float32(buffer);
      data.target[i] = tmp.data;
      buffer = tmp.buffer;
    }
    // Deserialize array length for message field [currentPos]
    tmp = _deserializer.uint32(buffer);
    len = tmp.data;
    buffer = tmp.buffer;
    // Deserialize message field [currentPos]
    data.currentPos = new Array(len);
    for (let i = 0; i < len; ++i) {
      tmp = _deserializer.float32(buffer);
      data.currentPos[i] = tmp.data;
      buffer = tmp.buffer;
    }
    return {
      data: data,
      buffer: buffer
    }
  }

  static datatype() {
    // Returns string type for a service object
    return 'arm/IKServiceRequest';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return 'f1c19c69d42f678c3d71ef5c322635c4';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    float32[] target
    float32[] currentPos
    
    `;
  }

};

class IKServiceResponse {
  constructor() {
    this.jointPos = [];
  }

  static serialize(obj, bufferInfo) {
    // Serializes a message object of type IKServiceResponse
    // Serialize the length for message field [jointPos]
    bufferInfo = _serializer.uint32(obj.jointPos.length, bufferInfo);
    // Serialize message field [jointPos]
    obj.jointPos.forEach((val) => {
      bufferInfo = _serializer.float32(val, bufferInfo);
    });
    return bufferInfo;
  }

  static deserialize(buffer) {
    //deserializes a message object of type IKServiceResponse
    let tmp;
    let len;
    let data = new IKServiceResponse();
    // Deserialize array length for message field [jointPos]
    tmp = _deserializer.uint32(buffer);
    len = tmp.data;
    buffer = tmp.buffer;
    // Deserialize message field [jointPos]
    data.jointPos = new Array(len);
    for (let i = 0; i < len; ++i) {
      tmp = _deserializer.float32(buffer);
      data.jointPos[i] = tmp.data;
      buffer = tmp.buffer;
    }
    return {
      data: data,
      buffer: buffer
    }
  }

  static datatype() {
    // Returns string type for a service object
    return 'arm/IKServiceResponse';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return '58ac670cd5282058b35f9d78ccf3fc5d';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    float32[] jointPos
    
    
    `;
  }

};

module.exports = {
  Request: IKServiceRequest,
  Response: IKServiceResponse
};
