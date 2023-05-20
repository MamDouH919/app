import 'package:flutter/cupertino.dart';

class ApiError {
  final String field;
  final String code;
  final String message;

  ApiError({required this.code, required this.field, required this.message});
}

class ApiException implements Exception {
  final List<ApiError> errors;
  ApiException(this.errors);
}
