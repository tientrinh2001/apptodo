import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../model/todo_model.dart';
import '../../../provider/home_controller.dart';
import '../../../utils.dart';
import '../../category/category_listview.dart';
import '../../widget/custom_text_form_field.dart';
import '../../widget/custom_text_form_field_with_tap.dart';
import '../../widget/date_picker.dart';
import 'reminder_form.dart';
import 'reminder_type_dropdown.dart';
import 'todo_button.dart';

class TodoForm extends ConsumerStatefulWidget {
  const TodoForm({this.todo, Key? key}) : super(key: key);
  final Todo? todo;

  @override
  ConsumerState<TodoForm> createState() => _TodoFormState();
}

class _TodoFormState extends ConsumerState<TodoForm> {
  TextEditingController detailTextEditingController = TextEditingController();
  TextEditingController dateTextEditingController = TextEditingController();
  TextEditingController timeTextEditingController = TextEditingController();
  TextEditingController periodTimeTextEditingController =
      TextEditingController();
  TextEditingController catTextEditingController = TextEditingController();
  TextEditingController reminderNameTextEditingController =
      TextEditingController();
  @override
  void initState() {
    if (widget.todo != null) {
      detailTextEditingController.text = widget.todo!.detail;
      dateTextEditingController.text =
          dateFormat.format(widget.todo!.createdDateTime.toDate());
      if (widget.todo!.reminderDateTime != null) {
        reminderNameTextEditingController.text =
            widget.todo!.reminderDateTime!.toString();
        timeTextEditingController.text =
            timeFormat.format(widget.todo!.reminderDateTime!).toString();
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController dateTextEditingController =
        TextEditingController(text: ref.watch(homeDateControllerProvider));

    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextFormField(
              keyboardType: TextInputType.multiline,
              hintText: 'input'.tr(),
              controller: detailTextEditingController,
              icon: const Icon(Icons.text_fields),
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 10),
            DatePicker(controller: dateTextEditingController),
            const SizedBox(height: 10),
            const CatListView(),
            const SizedBox(height: 10),
            ReminderTypeDropDown(todo: widget.todo),
            ReminderForm(
              todo: widget.todo,
              timeTextEditingController: timeTextEditingController,
              reminderNameTextEditingController:
                  reminderNameTextEditingController,
              dateTextEditingController: dateTextEditingController,
            ),
            const Spacer(),
            CreateOrUpdateButton(
              todo: widget.todo,
              dateTextEditingController: dateTextEditingController,
              detailTextEditingController: detailTextEditingController,
            )
          ],
        ));
  }
}

class DatePicker extends ConsumerWidget {
  const DatePicker({required this.controller, super.key});
  final TextEditingController controller;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = ref.watch(homeDateControllerProvider);
    return Consumer(builder: ((context, ref, child) {
      controller.text = date;
      return CustomTextFormFieldWithTap(
        controller: controller,
        onTap: () async {
          DateTime? pickedDate =
              await datePicker(context, DateTime.parse(date));
          if (pickedDate != null) {
            ref.read(homeDateControllerProvider.notifier).changeDate(
                  dateFormat.format(pickedDate),
                );
          }
        },
        prefixIcon: const Icon(Icons.calendar_today),
      );
    }));
  }
}
