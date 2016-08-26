// Auto-generated. Do not edit!

// (in-package arm.msg)


"use strict";

let _serializer = require('../base_serialize.js');
let _deserializer = require('../base_deserialize.js');
let _finder = require('../find.js');

//-----------------------------------------------------------

class SwitchPos {
  constructor() {
    this.pos = 0;
  }

  static serialize(obj, bufferInfo) {
    // Serializes a message object of type SwitchPos
    // Serialize message field [pos]
    bufferInfo = _serializer.int8(obj.pos, bufferInfo);
    return bufferInfo;
  }

  static deserialize(buffer) {
    //deserializes a message object of type SwitchPos
    let tmp;
    let len;
    let data = new SwitchPos();
    // Deserialize message field [pos]
    tmp = _deserializer.int8(buffer);
    data.pos = tmp.data;
    buffer = tmp.buffer;
    return {
      data: data,
      buffer: buffer
    }
  }

  static datatype() {
    // Returns string type for a message object
    return 'arm/SwitchPos';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return '618967a4b6ca1e2301a98e484144452b';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    int8 UP=1
    int8 NEUTRAL=0
    int8 DOWN=-1
    int8 pos
    
    `;
  }

};

// Constants for message
SwitchPos.Constants = {
  UP: 1,
  NEUTRAL: 0,
  DOWN: -1,
}

module.exports = SwitchPos;
