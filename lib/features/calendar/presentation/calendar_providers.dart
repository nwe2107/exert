import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/date_utils.dart';

enum CalendarViewMode { week, month }

final selectedCalendarDateProvider = StateProvider<DateTime>((ref) {
  return normalizeLocalDate(DateTime.now());
});

final calendarViewModeProvider = StateProvider<CalendarViewMode>((ref) {
  return CalendarViewMode.month;
});
