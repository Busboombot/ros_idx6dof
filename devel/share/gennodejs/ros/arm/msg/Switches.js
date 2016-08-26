// Auto-generated. Do not edit!

// (in-package arm.msg)


"use strict";

let _serializer = require('../base_serialize.js');
let _deserializer = require('../base_deserialize.js');
let _finder = require('../find.js');
let SwitchPos = require('./SwitchPos.js');

//-----------------------------------------------------------

class Switches {
  constructor() {
    this.positions = [];
  }

  static serialize(obj, bufferInfo) {
    // Serializes a message object of type Switches
    // Serialize the length for message field [positions]
    bufferInfo = _serializer.uint32(obj.positions.length, bufferInfo);
    // Serialize message field [positions]
    obj.positions.forEach((val) => {
      bufferInfo = SwitchPos.serialize(val, bufferInfo);
    });
    return bufferInfo;
  }

  static deserialize(buffer) {
    //deserializes a message object of type Switches
    let tmp;
    let len;
    let data = new Switches();
    // Deserialize array length for message field [positions]
    tmp = _deserializer.uint32(buffer);
    len = tmp.data;
    buffer = tmp.buffer;
    // Deserialize message field [positions]
    data.positions = new Array(len);
    for (let i = 0; i < len; ++i) {
      tmp = SwitchPos.deserialize(buffer);
      data.positions[i] = tmp.data;
      buffer = tmp.buffer;
    }
    return {
      data: data,
      buffer: buffer
    }
  }

  static datatype() {
    // Returns string type for a message object
    return 'arm/Switches';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return '72336361b4058bc9c050bf84bb606c9f';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    arm/SwitchPos[] positions
    
    ================================================================================
    MSG: arm/SwitchPos
    int8 UP=1
    int8 NEUTRAL=0
    int8 DOWN=-1
    int8 pos
    
    `;
  }

};

module.exports = Switches;
