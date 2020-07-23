import 'dart:convert';
import 'package:crypto/crypto.dart';

String generateSignature({String dataIn, signature}) {
  var encodedKey = utf8.encode(signature); // signature=encryption key
  var hmacSha256 = new Hmac(sha256, encodedKey); // HMAC-SHA256 with key
  var bytesDataIn = utf8.encode(dataIn); // encode the data to Unicode.
  var digest = hmacSha256.convert(bytesDataIn); // encrypt target data
  String singedValue = digest.toString();
  return singedValue;
}
