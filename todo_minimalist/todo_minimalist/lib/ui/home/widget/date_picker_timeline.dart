import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/theme.dart';
import '../../../provider/home_controller.dart';
import '../../../utils.dart';

class DatePickerTimeLine extends ConsumerWidget {
  const DatePickerTimeLine({
    required this.initialSelectedDate,
    Key? key,
  }) : super(key: key);
  final DateTime initialSelectedDate;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
      child: DatePicker(
        selectedTextColor: Theme.of(context).colorScheme.primary,
        DateTime.now(),
        height: size.height * .1,
        width: size.height * .09,
        initialSelectedDate: initialSelectedDate,
        dateTextStyle: titleStyle,
        dayTextStyle: subTitleStyle,
        monthTextStyle: subTitleStyle,
        locale: context.locale.languageCode,
        onDateChange: (date) {
          ref.read(homeDateControllerProvider.notifier).changeDate(
                dateFormat.format(date),
              );
        },
      ),
    );
  }
}
