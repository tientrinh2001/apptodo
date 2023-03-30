import 'package:flutter/material.dart';

Future<DateTime?> datePicker(BuildContext context, DateTime initialDate) {
  return showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: DateTime.now().subtract(const Duration(days: 365)),
    lastDate: DateTime.now().add(const Duration(days: 365)),
  );
}
