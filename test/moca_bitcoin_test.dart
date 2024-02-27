import 'package:moca_bitcoin/moca_bitcoin.dart';
import 'package:test/test.dart';

void main() {
  test('generate mnemonic', () {
    var mnemonic = MOCABitcoin.generateMnemonic();
    expect(mnemonic.split(' ').length, equals(12));
  });
}
