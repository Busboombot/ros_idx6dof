// Auto-generated. Do not edit!

// (in-package idxpendant.srv)


"use strict";

let _serializer = require('../base_serialize.js');
let _deserializer = require('../base_deserialize.js');
let _finder = require('../find.js');

//-----------------------------------------------------------

let SwitchPos = require('../msg/SwitchPos.js');

//-----------------------------------------------------------

class SwitchesSrvRequest {
  constructor() {
  }

  static serialize(obj, bufferInfo) {
    // Serializes a message object of type SwitchesSrvRequest
    return bufferInfo;
  }

  static deserialize(buffer) {
    //deserializes a message object of type SwitchesSrvRequest
    let tmp;
    let len;
    let data = new SwitchesSrvRequest();
    return {
      data: data,
      buffer: buffer
    }
  }

  static datatype() {
    // Returns string type for a service object
    return 'idxpendant/SwitchesSrvRequest';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return 'd41d8cd98f00b204e9800998ecf8427e';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    
    
    `;
  }

};

class SwitchesSrvResponse {
  constructor() {
    this.switches = [];
  }

  static serialize(obj, bufferInfo) {
    // Serializes a message object of type SwitchesSrvResponse
    // Serialize the length for message field [switches]
    bufferInfo = _serializer.uint32(obj.switches.length, bufferInfo);
    // Serialize message field [switches]
    obj.switches.forEach((val) => {
      bufferInfo = SwitchPos.serialize(val, bufferInfo);
    });
    return bufferInfo;
  }

  static deserialize(buffer) {
    //deserializes a message object of type SwitchesSrvResponse
    let tmp;
    let len;
    let data = new SwitchesSrvResponse();
    // Deserialize array length for message field [switches]
    tmp = _deserializer.uint32(buffer);
    len = tmp.data;
    buffer = tmp.buffer;
    // Deserialize message field [switches]
    data.switches = new Array(len);
    for (let i = 0; i < len; ++i) {
      tmp = SwitchPos.deserialize(buffer);
      data.switches[i] = tmp.data;
      buffer = tmp.buffer;
    }
    return {
      data: data,
      buffer: buffer
    }
  }

  static datatype() {
    // Returns string type for a service object
    return 'idxpendant/SwitchesSrvResponse';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return 'fdfeb5028b697838b970222e35ad759c';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    idxpendant/SwitchPos[] switches
    
    ================================================================================
    MSG: idxpendant/SwitchPos
    
    time time
    uint8 switch_no
    int8 switch_pos
    string switch_name
    `;
  }

};

module.exports = {
  Request: SwitchesSrvRequest,
  Response: SwitchesSrvResponse
};
