import 'dart:typed_data';
import 'package:pointycastle/digests/ripemd160.dart';
import 'package:pointycastle/digests/sha256.dart';

Uint8List hash160(Uint8List buffer) {
  Uint8List tmp = SHA256Digest().process(buffer);
  return RIPEMD160Digest().process(tmp);
}

Uint8List hash256(Uint8List buffer) {
  Uint8List tmp = SHA256Digest().process(buffer);
  return SHA256Digest().process(tmp);
}