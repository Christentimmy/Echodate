

import 'package:intl/intl.dart';

String convertDateToNormal(String? date) {
  if (date == null) return "";
  String normalizedTimestamp = date.replaceFirst(RegExp(r'\.\d+Z'), 'Z');
  DateTime dateTime = DateTime.parse(normalizedTimestamp).toUtc();
  DateFormat formatter = DateFormat("hh:mma MMM d yyyy");
  return formatter.format(dateTime);
}