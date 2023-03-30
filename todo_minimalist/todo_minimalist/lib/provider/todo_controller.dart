import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;

import '../model/category_model.dart';
import '../model/reminder_model.dart';
import '../model/todo_model.dart';
import '../provider/states/todo_state.dart';
import '../repository/todo_repository.dart';
import '../service/local_notification_service.dart';
import 'auth_controller.dart';
import 'category_controller.dart';

final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  return TodoRepository(ref, FirebaseFirestore.instance);
});

final todoControllerProvider =
    StateNotifierProvider<TodoController, TodoState>((ref) {
  return TodoController(ref);
});

class TodoController extends StateNotifier<TodoState> {
  TodoController(this.ref) : super(const TodoStateInitial());
  final Ref ref;

  Future<void> create({
    required String detail,
    required String createdDate,
    required Category category,
    required Reminder? reminder,
    required ReminderType reminderType,
  }) async {
    state = const TodoStateLoading();

    String uid = ref.watch(authRepositoryProvider).getUser!.uid;

    try {
      if (detail.isEmpty) {
        state = TodoStateError('todoNotEmpty'.tr());
      } else {
        var newTodo = Todo.newTodo(
          userId: uid,
          detail: detail,
          category: category,
          date: createdDate,
          color: category.color,
        );
        if (reminderType.code == ReminderCode.timeAlarm) {
          int notiId = genNotiId();
          await setReminder(
              id: notiId,
              category: category,
              detail: detail,
              reminderDateTime: reminder!.time);
          await ref.read(todoRepositoryProvider).create(newTodo.copyWith(
              category: category,
              notiId: notiId,
              reminderDateTime: reminder.time));
        } else {
          await ref.read(todoRepositoryProvider).create(newTodo);
        }
        var newCategory =
            category.copyWith(totalOfTask: category.totalOfTask + 1);
        await ref.read(catRepositoryProvider).update(newCategory);

        state = const TodoStateSuccess();
      }
    } catch (e) {
      state = TodoStateError(e.toString());
    }
  }

  Future<void> setReminder({
    required int id,
    required Category category,
    required String detail,
    required DateTime reminderDateTime,
  }) async {
    var time = tz.TZDateTime.from(reminderDateTime, tz.local);
    await LocalNotificationService.showNotification(
        id, category.categoryName, detail, time);
  }

  int genNotiId() {
    Random random = Random();
    return random.nextInt(10000);
  }

  Future<void> update({
    required String detail,
    required String createdDate,
    required Category category,
    required Todo todo,
    required Reminder? reminder,
    required ReminderType reminderType,
  }) async {
    state = const TodoStateLoading();

    try {
      if (detail.isEmpty) {
        state = TodoStateError('todoNotEmpty'.tr());
      } else {
        var updateTodo = todo.copyWith(
          detail: detail,
          date: createdDate,
          isDone: false,
          category: category,
        );

        if (reminderType.code == ReminderCode.none &&
            updateTodo.reminderDateTime != null) {
          /// turn off reminder
          await turnOffReminder(updateTodo, category);
        } else if (reminderType.code == ReminderCode.timeAlarm &&
            updateTodo.reminderDateTime != null &&
            reminder!.time != updateTodo.reminderDateTime) {
          /// update new reminder

          await updateReminder(updateTodo, category, reminder);
        } else if (reminderType.code == ReminderCode.timeAlarm &&
            updateTodo.reminderDateTime == null) {
          /// turn on reminder

          await turnOnReminder(updateTodo, category, reminder);
        } else {
          /// no thing

          await ref.read(todoRepositoryProvider).update(updateTodo);
        }
      }

      state = const TodoStateSuccess();
    } catch (e) {
      state = TodoStateError(e.toString());
    }
  }

  Future<void> turnOnReminder(
      Todo updateTodo, Category? category, Reminder? reminder) async {
    int notiId = genNotiId();
    var newTodo = updateTodo.copyWith(
      category: category,
      notiId: notiId,
      reminderDateTime: reminder!.time,
    );
    await ref.read(todoRepositoryProvider).update(newTodo);
    await setReminder(
      id: notiId,
      category: category!,
      detail: newTodo.detail,
      reminderDateTime: reminder.time,
    );
  }

  Future<void> turnOffReminder(Todo updateTodo, Category? category) async {
    await LocalNotificationService.cancelNotification(updateTodo.notiId!);
    var newTodo = updateTodo.copyWithForReminder(
      category: category,
      notiId: null,
      reminderDateTime: null,
    );
    await ref.read(todoRepositoryProvider).update(newTodo);
  }

  Future<void> updateReminder(
      Todo updateTodo, Category? category, Reminder? reminder) async {
    int notiId = genNotiId();
    var newTodo = updateTodo.copyWith(
        category: category, notiId: notiId, reminderDateTime: reminder!.time);
    await ref.read(todoRepositoryProvider).update(newTodo);
    await LocalNotificationService.cancelNotification(updateTodo.notiId!);
    await setReminder(
      id: notiId,
      category: category!,
      detail: newTodo.detail,
      reminderDateTime: reminder.time,
    );
  }

  Future<void> delete({
    required Todo todo,
  }) async {
    state = const TodoStateLoading();
    try {
      await ref.read(todoRepositoryProvider).delete(todo);
      if (todo.reminderDateTime != null) {
        await LocalNotificationService.cancelNotification(todo.notiId!);
      }
      state = const TodoDeleteSuccess();
    } catch (e) {
      state = TodoStateError(e.toString());
    }
  }

  Future<void> makeDone({
    required bool isDone,
    required Todo todo,
  }) async {
    state = const TodoStateLoading();
    try {
      var category =
          await ref.read(catRepositoryProvider).getById(todo.categoryCode);
      var newCategory = category!.copyWith(
          totalOfDone:
              isDone ? category.totalOfDone + 1 : category.totalOfDone - 1);
      await ref.read(catRepositoryProvider).update(newCategory);

      var newTodo = todo.copyWithForReminder(
          category: category,
          isDone: isDone,
          reminderDateTime: null,
          notiId: null);
      await ref.read(todoRepositoryProvider).update(newTodo);
      if (todo.reminderDateTime != null) {
        await LocalNotificationService.cancelNotification(todo.notiId!);
      }
      state = const TodoAttachStateSuccess();
    } catch (e) {
      state = TodoStateError(e.toString());
    }
  }
}
