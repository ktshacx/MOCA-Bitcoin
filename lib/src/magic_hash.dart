import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:moca_bitcoin/src/crypto.dart';
import 'package:moca_bitcoin/src/network.dart';

Uint8List magicHash(String message) {
  Uint8List messagePrefix = utf8.encode(bitcoin.messagePrefix);
  int messageVIsize = encodingLength(message.length);
  int length = messagePrefix.length + messageVIsize + message.length;
  Uint8List buffer = Uint8List(length);
  buffer.setRange(0, messagePrefix.length, messagePrefix);
  encode(message.length, buffer, messagePrefix.length);
  buffer.setRange(
      messagePrefix.length + messageVIsize, length, utf8.encode(message));
  return hash256(buffer);
}

Uint8List encode(int number, [Uint8List? buffer, int? offset]) {
  if (!isUint(number, 53)) ;

  buffer = buffer ?? Uint8List(encodingLength(number));
  offset = offset ?? 0;
  ByteData bytes = buffer.buffer.asByteData();
  // 8 bit
  if (number < 0xfd) {
    bytes.setUint8(offset, number);
    // 16 bit
  } else if (number <= 0xffff) {
    bytes.setUint8(offset, 0xfd);
    bytes.setUint16(offset + 1, number, Endian.little);

    // 32 bit
  } else if (number <= 0xffffffff) {
    bytes.setUint8(offset, 0xfe);
    bytes.setUint32(offset + 1, number, Endian.little);

    // 64 bit
  } else {
    bytes.setUint8(offset, 0xff);
    bytes.setUint32(offset + 1, number, Endian.little);
    bytes.setUint32(offset + 5, (number ~/ 0x100000000) | 0, Endian.little);
  }

  return buffer;
}

int encodingLength(int number) {
  if (!isUint(number, 53)) throw ArgumentError("Expected UInt53");
  return (number < 0xfd
      ? 1
      : number <= 0xffff ? 3 : number <= 0xffffffff ? 5 : 9);
}

bool isUint(int value, int bit) {
  return (value >= 0 && value <= pow(2, bit) - 1);
}