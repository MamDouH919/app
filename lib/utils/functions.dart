String? arabicDayName(String value) {
  switch (value.toLowerCase()) {
    case 'sat':
      return "السبت";
      break;
    case 'sun':
      return "الأحد";
      break;

    case 'mon':
      return "الإثنين";
      break;

    case 'tue':
      return "الثلاثاء";
      break;

    case 'wed':
      return "الأربعاء";
      break;

    case 'thu':
      return "الخميس";
      break;

    case 'fri':
      return "الجمعة";
      break;
  }
  return null;
}

String replaceAmPM(String value) {
  value = value.replaceAll('am', 'صباحاً');
  value = value.replaceAll('pm', 'مساءاً');
  value = value.replaceAll('AM', 'صباحاً');
  value = value.replaceAll('PM', 'مساءاً');
  return value;
}
