import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../model/reminder_model.dart';
import '../../../model/todo_model.dart';
import '../../../provider/home_controller.dart';
import '../../../provider/reminder_controller.dart';
import '../../../utils.dart';
import '../../widget/custom_text_form_field_with_tap.dart';
import '../../widget/date_picker.dart';
import '../../widget/time_picker.dart';
import 'todo_dialog.dart';

class ReminderForm extends ConsumerWidget {
  const ReminderForm({
    required this.timeTextEditingController,
    required this.reminderNameTextEditingController,
    required this.dateTextEditingController,
    required this.todo,
    super.key,
  });
  final Todo? todo;
  final TextEditingController timeTextEditingController;
  final TextEditingController reminderNameTextEditingController;
  final TextEditingController dateTextEditingController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(builder: ((context, ref, child) {
      final reminderTypeState = ref.watch(reminderTypeControllerProvider(todo));
      if (reminderTypeState.code == ReminderCode.timeAlarm) {
        return Consumer(builder: ((context, ref, child) {
          final state = ref.watch(reminderControllerProvider(todo));
          timeTextEditingController.text = timeFormat.format(state.time);
          reminderNameTextEditingController.text = state.name;
          return Column(
            children: [
              CustomTextFormFieldWithTap(
                controller: reminderNameTextEditingController,
                onTap: () async {
                  await choosePeriodTime(context, todo);
                },
                prefixIcon: const Icon(Icons.timer),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: CustomTextFormFieldWithTap(
                        controller: dateTextEditingController,
                        onTap: () async {
                          final date = ref.watch(homeDateControllerProvider);
                          DateTime? pickedDate =
                              await datePicker(context, DateTime.parse(date));
                          if (pickedDate != null) {
                            ref
                                .read(homeDateControllerProvider.notifier)
                                .changeDate(
                                  dateFormat.format(pickedDate),
                                );
                          }
                        },
                        prefixIcon: const Icon(Icons.calendar_today),
                      )),
                  const SizedBox(width: 20),
                  Expanded(
                    child: CustomTextFormFieldWithTap(
                      controller: timeTextEditingController,
                      onTap: () async {
                        var time = await timePicker(context);
                        if (time != null) {
                          ref
                              .read(reminderControllerProvider(todo).notifier)
                              .chooseTime(time);
                        }
                      },
                      prefixIcon: const Icon(Icons.timer),
                    ),
                  ),
                ],
              ),
            ],
          );
        }));
      } else {
        return const SizedBox.shrink();
      }
    }));
  }
}
