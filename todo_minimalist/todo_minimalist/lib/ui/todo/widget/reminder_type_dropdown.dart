import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../model/reminder_model.dart';
import '../../../model/todo_model.dart';
import '../../../provider/reminder_controller.dart';

class ReminderTypeDropDown extends StatefulWidget {
  const ReminderTypeDropDown({required this.todo, Key? key}) : super(key: key);
  final Todo? todo;
  @override
  State<ReminderTypeDropDown> createState() => _ReminderTypeDropDownState();
}

class _ReminderTypeDropDownState extends State<ReminderTypeDropDown> {
  List<ReminderType> reminderTypeList = [];
  late ReminderType dropdownValue;
  @override
  void initState() {
    reminderTypeList.addAll(ReminderType.getList());
    dropdownValue = reminderTypeList.first;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: ((context, ref, child) {
      final state = ref.watch(reminderTypeControllerProvider(widget.todo));
      return SizedBox(
          width: double.infinity,
          child: DropdownButton<ReminderType>(
            icon: const Visibility(
                visible: false, child: Icon(Icons.arrow_downward)),
            value: state,
            underline: Container(height: 1),
            onChanged: (ReminderType? value) {
              setState(() {
                dropdownValue = value!;
                ref
                    .read(reminderTypeControllerProvider(widget.todo).notifier)
                    .changeType(dropdownValue);
              });
            },
            items: reminderTypeList
                .map<DropdownMenuItem<ReminderType>>((ReminderType value) {
              return DropdownMenuItem<ReminderType>(
                value: value,
                child: Text(
                  value.name,
                  style: const TextStyle(fontSize: 16),
                ),
              );
            }).toList(),
          ));
    }));
  }
}
