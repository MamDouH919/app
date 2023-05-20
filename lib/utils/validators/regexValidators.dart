enum RegexTypes { email }

bool regexValid(RegexTypes type, String value) {
  Pattern pattern;
  switch (type) {
    case RegexTypes.email:
      pattern =
          r'^(([^<>()[\]\\.,,:\s@\"]+(\.[^<>()[\]\\.,,:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      break;
    default:
      return false;
  }

  return RegExp(pattern.toString()).hasMatch(value);
}
