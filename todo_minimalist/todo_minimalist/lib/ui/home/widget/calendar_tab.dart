import 'package:badges/badges.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../model/todo_model.dart';
import '../../../../provider/auth_controller.dart';
import '../../../../provider/todo_controller.dart';
import '../../../../utils.dart';
import '../../todo/widget/todo_staggered_grid.dart';

class CalendarTab extends ConsumerStatefulWidget {
  const CalendarTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CalendarTabState();
}

class _CalendarTabState extends ConsumerState<CalendarTab> {
  DateTime daySelected = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final uid = ref.read(authRepositoryProvider).getUser!.uid;
    return StreamBuilder(
      stream: ref.read(todoRepositoryProvider).loadForCalendar(uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.error != null) {
          return Center(child: Text('someErrorOccurred'.tr()));
        }
        var todoList = snapshot.data as List<Todo>;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar<Todo?>(
              headerStyle: const HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
              ),
              eventLoader: (day) {
                return todoList
                    .where((element) => element.date == dateFormat.format(day))
                    .toList();
              },
              onDaySelected: (day, day1) {
                setState(() {
                  daySelected = day1;
                });
              },
              calendarBuilders:
                  CalendarBuilders(markerBuilder: (context, day, events) {
                return events.isNotEmpty
                    ? Align(
                        alignment: Alignment.topRight,
                        child: Badge(
                          badgeContent: Text(
                            events.length.toString(),
                            style: const TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ))
                    : null;
              }),
              firstDay: DateTime.now().subtract(const Duration(days: 365)),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              focusedDay: daySelected,
              currentDay: daySelected,
              daysOfWeekHeight: 25,
              rowHeight: 40,
            ),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                  child: TodoStaggeredGrid(
                todos: todoList
                    .where((element) =>
                        element.date == dateFormat.format(daySelected))
                    .toList(),
              )),
            ),
          ],
        );
      },
    );
  }
}
