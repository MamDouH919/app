import 'package:flutter/cupertino.dart';
import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class User {
  String? id;
  String? email;
  String? name;
  String? token;
  String? type;

  User({
    this.id,
    this.email,
    this.name,
    this.token,
    this.type,
  });
}
