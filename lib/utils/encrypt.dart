import 'package:crypto/crypto.dart';
import 'dart:convert';

String generateSha1(String input) {
  return sha1.convert(utf8.encode(input)).toString();
}
