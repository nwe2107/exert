import 'package:flutter/material.dart';

DateTime normalizeLocalDate(DateTime date) {
  return DateUtils.dateOnly(date.toLocal());
}

bool isSameLocalDay(DateTime a, DateTime b) {
  return normalizeLocalDate(a) == normalizeLocalDate(b);
}

int daysBetween(DateTime from, DateTime to) {
  final start = normalizeLocalDate(from);
  final end = normalizeLocalDate(to);
  return end.difference(start).inDays;
}

Iterable<DateTime> daysInRange(DateTime start, DateTime endInclusive) sync* {
  var current = normalizeLocalDate(start);
  final end = normalizeLocalDate(endInclusive);
  while (!current.isAfter(end)) {
    yield current;
    current = current.add(const Duration(days: 1));
  }
}
