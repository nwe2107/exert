import 'package:intl/intl.dart';

final _routeDateFormat = DateFormat('yyyy-MM-dd');

String encodeRouteDate(DateTime date) {
  return _routeDateFormat.format(date);
}

DateTime decodeRouteDate(String raw) {
  return DateTime.parse(raw);
}
