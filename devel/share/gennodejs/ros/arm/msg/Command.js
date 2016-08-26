// Auto-generated. Do not edit!

// (in-package arm.msg)


"use strict";

let _serializer = require('../base_serialize.js');
let _deserializer = require('../base_deserialize.js');
let _finder = require('../find.js');

//-----------------------------------------------------------

class Command {
  constructor() {
    this.cmd = 0;
    this.params = [];
  }

  static serialize(obj, bufferInfo) {
    // Serializes a message object of type Command
    // Serialize message field [cmd]
    bufferInfo = _serializer.uint8(obj.cmd, bufferInfo);
    // Serialize the length for message field [params]
    bufferInfo = _serializer.uint32(obj.params.length, bufferInfo);
    // Serialize message field [params]
    obj.params.forEach((val) => {
      bufferInfo = _serializer.int32(val, bufferInfo);
    });
    return bufferInfo;
  }

  static deserialize(buffer) {
    //deserializes a message object of type Command
    let tmp;
    let len;
    let data = new Command();
    // Deserialize message field [cmd]
    tmp = _deserializer.uint8(buffer);
    data.cmd = tmp.data;
    buffer = tmp.buffer;
    // Deserialize array length for message field [params]
    tmp = _deserializer.uint32(buffer);
    len = tmp.data;
    buffer = tmp.buffer;
    // Deserialize message field [params]
    data.params = new Array(len);
    for (let i = 0; i < len; ++i) {
      tmp = _deserializer.int32(buffer);
      data.params[i] = tmp.data;
      buffer = tmp.buffer;
    }
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
    return 'ac224fe040657a122ab633b7a19a6e0a';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    uint8 cmd
    int32[] params
    
    
    `;
  }

};

module.exports = Command;
