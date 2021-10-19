import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:base32/base32.dart';
import 'package:dart_otp/dart_otp.dart';
import 'package:flutter_get_x_practice/model/NukiActionModel.dart';

class Encoder{
  static const String _nuki_x_password = 'kooki2';

  NukiActionButton encodeString({String password = _nuki_x_password}){
    int totpNonce = getTimestamp();
    // print('_nuki_x_password: $password');
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    // print('hexString: $digest');
    var hexSubStr = digest.toString().substring(0,20);
    // print('hexSubStr(0,20): $hexSubStr');
    var base32Hex = base32.encodeHexString(hexSubStr);
    // print('base32Hex: $base32Hex');
    base32Hex = base32Hex.padLeft(16,'A');
    // print('base32HexLeftPad: $base32Hex');


    // print('totpNonce: $totpNonce');
    var digestTopNonce = sha256.convert(utf8.encode(totpNonce.toString()));
    // print('digestTopNonce: $digestTopNonce');
    var hexSubStrTopNonce = digestTopNonce.toString().substring(0,10);
    // print('hexSubStrTopNonce: $hexSubStrTopNonce');
    var base32HexTopNonce = base32.encodeHexString(hexSubStrTopNonce);
    // print('base32HexTopNonce: $base32HexTopNonce');
    base32HexTopNonce = base32HexTopNonce.padLeft(8,'A');
    // print('base32HexTopNoncePadLeft: $base32HexTopNonce');

    var secret = '$base32Hex$base32HexTopNonce';
    // print('secret: $secret');
    TOTP totp = TOTP(secret: secret);
    // print('otp: ${totp.now()}');
    return NukiActionButton(totp.now(),totpNonce.toString());
  }

  int getTimestamp(){
    return DateTime.now().toUtc().millisecondsSinceEpoch;
  }
}