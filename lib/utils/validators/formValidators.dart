import 'package:starkids_app/utils/validators/regexValidators.dart';

String? composeValidator(String value, List<dynamic> validators) {
  String error;
  for (final dynamic validator in validators) {
    if (validator is String Function(String)) {
      error = validator(value);
    } else if (validator is List &&
        validator[0] is String Function(String, dynamic)) {
      error = (validator[0] as String Function(String, dynamic))(
          value, validator[1]);
    } else {
      throw 'Invalid validators composition';
    }
    if (error != null) return error;
  }
  return null;
}

String notEmptyValidator(String value) {
  if (value.isEmpty) {
    return 'يجب ملئ البيانات';
  }
  return '';
}

String? notEmptySelector(String value) {
  if (value == null) {
    return 'يجب ملئ البيانات';
  }
  return null;
}

String? textMatchValidator(String value, String originalValue) {
  if (value != originalValue) {
    return 'كلمة المرور لا تتطابق';
  }
  return null;
}

String? emailValidator(String value) {
  if (value.isEmpty) {
    return 'يجب ادخال البريد الالكترونى';
  }
  if (!regexValid(RegexTypes.email, value)) {
    return 'يجب ادخل بريد الكترونى صحيح';
  }
  return null;
}

String? integerValidator(String value) {
  if (int.tryParse(value) == null) {
    return 'يجب ادخال ارقام فقط';
  }
  return null;
}

String? numberValidator(String value) {
  if (double.tryParse(value) == null) {
    return 'Please enter only numbers';
  }
  return null;
}

String? minNumberValidator(String value, double min) {
  final String? isNumber = numberValidator(value);
  if (isNumber != null) {
    return isNumber;
  }

  if (double.tryParse(value)! < min) {
    return 'Field must at least be $min';
  }
  return null;
}

String? maxNumberValidator(String value, double max) {
  final String? isNumber = numberValidator(value);
  if (isNumber != null) {
    return isNumber;
  }

  if (double.tryParse(value)! > max) {
    return 'Field must at monst be $max';
  }
  return null;
}

String? nationalIdValidator(String value) {
  if (value.length != 14) {
    return 'يجب ان يحتوى على 14 رقم';
  }
  return null;
}

String? exactLengthValidator(String value, int length) {
  if (value.length != length) {
    return 'Field must have $length characters';
  }
  return null;
}

String? minLengthValidator(String value, int length) {
  if (value.length < length) {
    return 'Field must at least have $length characters';
  }
  return null;
}

String? maxLengthValidator(String value, int length) {
  if (value.length > length) {
    return 'Field must at most have $length characters';
  }
  return null;
}
