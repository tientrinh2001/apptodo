import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../provider/home_controller.dart';
import '../../../provider/reminder_controller.dart';

import '../../../model/todo_model.dart';

class ReminderGirdView extends ConsumerStatefulWidget {
  const ReminderGirdView({required this.todo, super.key});
  final Todo? todo;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TimeGirdViewState();
}

class _TimeGirdViewState extends ConsumerState<ReminderGirdView> {
  @override
  Widget build(BuildContext context) {
    var date = ref.watch(homeDateControllerProvider);
    var timeList = ref.watch(reminderListProvider(DateTime.parse(date)));
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.15,
        width: MediaQuery.of(context).size.width * 0.6,
        child: GridView.builder(
            itemCount: timeList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              childAspectRatio: 6 / 1,
            ),
            itemBuilder: (context, i) {
              return Consumer(builder: ((context, ref, child) {
                var state = ref.watch(reminderControllerProvider(widget.todo));

                return ChoiceChip(
                  padding: EdgeInsets.zero,
                  labelPadding: EdgeInsets.zero,
                  selected: state.time.minute == timeList[i].time.minute,
                  label: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Align(
                          child: Text(
                        timeList[i].name,
                      ))),
                  shape: const StadiumBorder(side: BorderSide(width: 1.5)),
                  onSelected: (selected) {
                    setState(() {
                      ref
                          .read(
                              reminderControllerProvider(widget.todo).notifier)
                          .changePeriod(state = selected ? timeList[i] : state);
                    });
                    Navigator.of(context).pop();
                  },
                );
              }));
            }));
  }
}
