// Auto-generated. Do not edit!

// (in-package arm.msg)


"use strict";

let _serializer = require('../base_serialize.js');
let _deserializer = require('../base_deserialize.js');
let _finder = require('../find.js');

//-----------------------------------------------------------

class Command {
  constructor() {
    this.switch_no = 0;
    this.switch_pos = 0;
    this.switch_name = '';
  }

  static serialize(obj, bufferInfo) {
    // Serializes a message object of type Command
    // Serialize message field [switch_no]
    bufferInfo = _serializer.uint8(obj.switch_no, bufferInfo);
    // Serialize message field [switch_pos]
    bufferInfo = _serializer.uint8(obj.switch_pos, bufferInfo);
    // Serialize message field [switch_name]
    bufferInfo = _serializer.string(obj.switch_name, bufferInfo);
    return bufferInfo;
  }

  static deserialize(buffer) {
    //deserializes a message object of type Command
    let tmp;
    let len;
    let data = new Command();
    // Deserialize message field [switch_no]
    tmp = _deserializer.uint8(buffer);
    data.switch_no = tmp.data;
    buffer = tmp.buffer;
    // Deserialize message field [switch_pos]
    tmp = _deserializer.uint8(buffer);
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
    // Returns string type for a message object
    return 'arm/Command';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return 'ef707ea7563d7ccdfdd8bb776d91afd2';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    uint8 switch_no
    uint8 switch_pos
    string switch_name
    `;
  }

};

module.exports = Command;
