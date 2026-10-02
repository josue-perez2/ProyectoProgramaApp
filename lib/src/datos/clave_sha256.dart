import 'dart:convert';

import 'package:crypto/crypto.dart' as crypto;

abstract final class Clave {
  static String sha256(String password) {
    return crypto.sha256.convert(utf8.encode(password)).toString();
  }
}
