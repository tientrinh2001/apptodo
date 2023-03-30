import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

Future<DateTime?> timePicker(BuildContext context) {
  return DatePicker.showTimePicker(
    context,
    showSecondsColumn: false,
    locale: context.locale.languageCode == 'vi' ? LocaleType.vi : LocaleType.en,
    theme: DatePickerTheme(
      backgroundColor: Theme.of(context).colorScheme.primary,
      cancelStyle: textStyle,
      doneStyle: textStyle,
      itemStyle: textStyle,
    ),
  );
}

const textStyle = TextStyle(
  color: Colors.white,
);
