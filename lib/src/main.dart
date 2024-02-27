import 'dart:convert';
import 'dart:typed_data';
import 'package:bip32/bip32.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:http/http.dart' as http;
// import 'package:flutter/foundation.dart';
import 'package:moca_bitcoin/src/crypto.dart';
import 'package:moca_bitcoin/src/magic_hash.dart';
import 'package:moca_bitcoin/src/network.dart';
import 'package:bs58check/bs58check.dart' as bs58check;

class MOCABitcoin {
  static String generateMnemonic() {
    return bip39.generateMnemonic();
  }

  static Uint8List getPublicKey(String mnemonic) {
    final seedHex = bip39.mnemonicToSeed(mnemonic);
    final wallet = BIP32.fromSeed(seedHex, NetworkType(wif: bitcoin.wif, bip32: bitcoin.bip32));
    return wallet.publicKey;
  }

  static Uint8List? getPrivateKey(String mnemonic) {
    final seedHex = bip39.mnemonicToSeed(mnemonic);
    final wallet = BIP32.fromSeed(seedHex, NetworkType(wif: bitcoin.wif, bip32: bitcoin.bip32));
    return wallet.privateKey;
  }

  static String getAddress(Uint8List publicKey){
    final payload = Uint8List(21);
    payload.buffer.asByteData().setUint8(0, bitcoin.pubKeyHash);
    payload.setRange(1, payload.length, hash160(publicKey));
    return bs58check.encode(payload);
  }

  static Uint8List sign(String message, Uint8List seed) {
    Uint8List messageHash = magicHash(message);
    return BIP32.fromSeed(seed).sign(messageHash);
  }

  static bool verify(String message, Uint8List signature, Uint8List seed) {
    Uint8List messageHash = magicHash(message);
    return BIP32.fromSeed(seed).verify(messageHash, signature);
  }

  static Future<double> getBalance(String address) async {
  final apiUrl = 'https://api.blockchair.com/bitcoin/dashboards/address/$address';
  try {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final balance = jsonResponse['data'][address]['address']['balance'];
      return double.parse(balance);
    } else {
      return 0.0;
    }
  } catch (e) {
    return 0.0;
  }
}
}
