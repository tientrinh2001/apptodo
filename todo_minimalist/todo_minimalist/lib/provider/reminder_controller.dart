import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/reminder_model.dart';
import '../model/todo_model.dart';
import '../utils.dart';
import 'home_controller.dart';

final reminderTypeControllerProvider = StateNotifierProvider.autoDispose
    .family<ReminderTypeController, ReminderType, Todo?>((_, todo) {
  return ReminderTypeController(todo);
});

final reminderControllerProvider = StateNotifierProvider.autoDispose
    .family<ReminderController, Reminder, Todo?>((ref, todo) {
  return ReminderController(ref, todo);
});

final reminderListProvider =
    Provider.family.autoDispose<List<Reminder>, DateTime>(
  (_, date) {
    return Reminder.getList(date);
  },
);

class ReminderController extends StateNotifier<Reminder> {
  ReminderController(this.ref, this.todo)
      : super(Reminder.getList(
                DateTime.parse(ref.watch(homeDateControllerProvider)))
            .first) {
    init();
  }
  final Todo? todo;
  final Ref ref;

  init() {
    if (todo != null && todo!.reminderDateTime != null && !todo!.isDone) {
      var reminderList = Reminder.getList(
          DateTime.parse(ref.watch(homeDateControllerProvider)));
      var isOfReminderList = reminderList.any(
          (element) => element.time.minute == todo!.reminderDateTime!.minute);
      if (isOfReminderList) {
        var newState = Reminder.getList(
                DateTime.parse(ref.watch(homeDateControllerProvider)))
            .firstWhere((element) =>
                element.time.minute == todo!.reminderDateTime!.minute);
        state = newState;
      } else {
        var seletedDate = DateTime.parse(ref.watch(homeDateControllerProvider));
        DateTime reminderDateTime = DateTime(
          seletedDate.year,
          seletedDate.month,
          seletedDate.day,
          todo!.reminderDateTime!.hour,
          todo!.reminderDateTime!.minute,
          todo!.reminderDateTime!.second,
        );
        String name = timeUntil(reminderDateTime);
        var newState = Reminder(name: name, time: reminderDateTime);
        state = newState;
      }
    }
  }

  changePeriod(Reminder newState) {
    state = newState;
  }

  chooseTime(DateTime? timeOfDay) {
    DateTime seletedDate =
        DateTime.parse(ref.watch(homeDateControllerProvider));
    DateTime reminderDateTime = DateTime(
      seletedDate.year,
      seletedDate.month,
      seletedDate.day,
      timeOfDay!.hour,
      timeOfDay.minute,
      timeOfDay.second,
    );

    bool isReminder = reminderDateTime.isAfter(now);
    String name = timeUntil(reminderDateTime);
    if (isReminder) {
      Reminder reminder;
      if (reminderDateTime.difference(now).inHours > 0) {
        reminder = Reminder(name: name, time: reminderDateTime);
      } else {
        reminder = Reminder(name: name, time: reminderDateTime);
      }
      state = reminder;
    }
  }
}

class ReminderTypeController extends StateNotifier<ReminderType> {
  final Todo? todo;
  ReminderTypeController(this.todo) : super(ReminderType.getList().first) {
    init();
  }

  init() {
    if (todo != null && todo!.reminderDateTime != null && !todo!.isDone) {
      state = ReminderType.getList().last;
    }
  }

  changeType(ReminderType newType) {
    state = newType;
  }
}
