// Auto-generated. Do not edit!

// (in-package idxpendant.srv)


"use strict";

let _serializer = require('../base_serialize.js');
let _deserializer = require('../base_deserialize.js');
let _finder = require('../find.js');

//-----------------------------------------------------------


//-----------------------------------------------------------

class SwitchSrvRequest {
  constructor() {
    this.switch_ref = '';
  }

  static serialize(obj, bufferInfo) {
    // Serializes a message object of type SwitchSrvRequest
    // Serialize message field [switch_ref]
    bufferInfo = _serializer.string(obj.switch_ref, bufferInfo);
    return bufferInfo;
  }

  static deserialize(buffer) {
    //deserializes a message object of type SwitchSrvRequest
    let tmp;
    let len;
    let data = new SwitchSrvRequest();
    // Deserialize message field [switch_ref]
    tmp = _deserializer.string(buffer);
    data.switch_ref = tmp.data;
    buffer = tmp.buffer;
    return {
      data: data,
      buffer: buffer
    }
  }

  static datatype() {
    // Returns string type for a service object
    return 'idxpendant/SwitchSrvRequest';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return '4cad5331d44c41d03096e603e96fba45';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    string switch_ref
    
    `;
  }

};

class SwitchSrvResponse {
  constructor() {
    this.time = {secs: 0, nsecs: 0};
    this.switch_no = 0;
    this.switch_pos = 0;
    this.switch_name = '';
  }

  static serialize(obj, bufferInfo) {
    // Serializes a message object of type SwitchSrvResponse
    // Serialize message field [time]
    bufferInfo = _serializer.time(obj.time, bufferInfo);
    // Serialize message field [switch_no]
    bufferInfo = _serializer.uint8(obj.switch_no, bufferInfo);
    // Serialize message field [switch_pos]
    bufferInfo = _serializer.int8(obj.switch_pos, bufferInfo);
    // Serialize message field [switch_name]
    bufferInfo = _serializer.string(obj.switch_name, bufferInfo);
    return bufferInfo;
  }

  static deserialize(buffer) {
    //deserializes a message object of type SwitchSrvResponse
    let tmp;
    let len;
    let data = new SwitchSrvResponse();
    // Deserialize message field [time]
    tmp = _deserializer.time(buffer);
    data.time = tmp.data;
    buffer = tmp.buffer;
    // Deserialize message field [switch_no]
    tmp = _deserializer.uint8(buffer);
    data.switch_no = tmp.data;
    buffer = tmp.buffer;
    // Deserialize message field [switch_pos]
    tmp = _deserializer.int8(buffer);
    data.switch_pos = tmp.data;
    buffer = tmp.buffer;
    // Deserialize message field [switch_name]
    tmp = _deserializer.string(buffer);
    data.switch_name = tmp.data;
    buffer = tmp.buffer;
    return {
      data: data,
      buffer: buffer
    }
  }

  static datatype() {
    // Returns string type for a service object
    return 'idxpendant/SwitchSrvResponse';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return '6d256e445299745010b61ca2b82e5e4a';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    time time
    uint8 switch_no
    int8 switch_pos
    string switch_name
    
    `;
  }

};

module.exports = {
  Request: SwitchSrvRequest,
  Response: SwitchSrvResponse
};
