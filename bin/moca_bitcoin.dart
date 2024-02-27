import 'package:moca_bitcoin/moca_bitcoin.dart';

void main(List<String> arguments) {
  var mnemonic = MOCABitcoin.generateMnemonic();
  print('Mnemonic: ${mnemonic}');

  var publicKey = MOCABitcoin.getPublicKey(mnemonic);
  print('Public Key: ${publicKey.toString()}');

  var address = MOCABitcoin.getAddress(publicKey);
  print('Address: ${address}');

  MOCABitcoin.getBalance(address).then((balance) => {
    print('Balance: ${balance} BTC')
  });
  
}