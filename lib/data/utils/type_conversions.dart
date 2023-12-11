double? parseDouble(dynamic numberVal) {
  if (numberVal is int) {
    return numberVal.toDouble();
  } else if (numberVal is double) {
    return numberVal;
  } else if (numberVal is String) {
    return double.parse(numberVal);
  } else {
    return null;
  }
}

int? parseInt(dynamic numberVal) {
  if (numberVal is int) {
    return numberVal;
  } else if (numberVal is double) {
    return numberVal.toInt();
  } else if (numberVal is String) {
    return int.parse(numberVal);
  } else {
    return null;
  }
}

String formatDateTime(DateTime? dateTime) {
  if (dateTime == null) {
    return "";
  }
  return "${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
}

DateTime parseDateTime(String dateString) {
  int extraHours = 0;
  if (dateString.contains('PM')) {
    extraHours = 12;
  }
  dateString = dateString.replaceAll(' AM', '');
  dateString = dateString.replaceAll(' PM', '');

  DateTime newDatetime = DateTime.parse(dateString);
  newDatetime = newDatetime.add(Duration(hours: extraHours));

  return newDatetime;
}
