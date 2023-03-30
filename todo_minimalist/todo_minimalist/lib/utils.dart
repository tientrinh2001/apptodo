import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

final dateFormat = DateFormat('yyyy-MM-dd');
final timeFormat = DateFormat('HH:mm');

const catIcon = Icon(Icons.folder);
const projectIcon = Icon(Icons.task);
const taskIcon = Icon(Icons.task);
const todoIcon = Icon(Icons.checklist);
const dateIcon = Icon(Icons.calendar_today);
const chatIcon = Icon(Icons.chat);
const buttonHeight = 60.0;

var now = DateTime.now();

String timeUntil(DateTime date) {
  return timeago.format(date, locale: 'vi', allowFromNow: true);
}
