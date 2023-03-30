import '../utils.dart';

class Reminder {
  final String name;
  final DateTime time;
  const Reminder({required this.name, required this.time});
  static List<Reminder> getList(DateTime date) {
    var now = DateTime.now();
    List<Reminder> timeList = [];
    for (int i = 5; i < 50; i += 5) {
      var time = DateTime(
              date.year, date.month, date.day, now.hour, now.minute, now.second)
          .add(Duration(minutes: i));
      String name = timeUntil(time);
      timeList.add(Reminder(name: name, time: time));
    }

    return timeList;
  }
}

enum ReminderCode { none, timeAlarm }

class ReminderType {
  final String name;
  final ReminderCode code;
  const ReminderType({required this.name, required this.code});
  static List<ReminderType> getList() {
    List<ReminderType> list = [];
    list.add(
        const ReminderType(name: 'Không nhắc nhở', code: ReminderCode.none));
    list.add(const ReminderType(
        name: 'Thời gian báo thức', code: ReminderCode.timeAlarm));
    return list;
  }
}
