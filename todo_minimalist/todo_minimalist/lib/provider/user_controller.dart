import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../model/project_model.dart';
import 'auth_controller.dart';
import 'states/user_state.dart';
import '../repository/user_repository.dart';

import '../model/user_model.dart';

final userRepositoryProvider = Provider.autoDispose<UserRepository>(
    (ref) => UserRepository(ref, FirebaseFirestore.instance));

final userControllerProvider =
    StateNotifierProvider.autoDispose<UserController, UserState>(
        (ref) => UserController(ref));

class UserController extends StateNotifier<UserState> {
  UserController(this.ref) : super(const UserStateInitial());
  final Ref ref;

  Future<void> create() async {
    state = const UserStateLoading();
    try {
      await ref.read(userRepositoryProvider).create();
      state = const UserStateSuccess();
    } catch (e) {
      state = UserStateError(e.toString());
    }
  }

  void closeBottomSheet() {
    state = const UserStateInitial();
  }

  void openProjectSheet(Project project) {
    state = UserStateOpenProjectSheet(project);
  }

  void openTaskSheet(Project project) {
    state = UserStateOpenTaskSheet(project);
  }

  void loadUser(List<User> userList) {
    state = UserStateLoadSuccess(userList);
  }

  Future<void> search(String email, Project project) async {
    state = const UserStateLoading();
    try {
      if (email.isNotEmpty) {
        List<User> userList = [];
        final currentEmail = ref.watch(authRepositoryProvider).getUser!.email;
        var result =
            await ref.read(userRepositoryProvider).search(email, currentEmail!);
        if (result.isNotEmpty) {
          for (var user in result) {
            int index =
                project.member.indexWhere((element) => element.id == user.id);
            if (index == -1) userList.add(user);
          }
        }
        state = UserStateLoadSuccess(userList);
      } else {
        state = const UserStateLoadSuccess([]);
      }
    } catch (e) {
      state = UserStateError(e.toString());
    }
  }

  Future<void> select(
      List<User> userList, User userSelected, bool selected) async {
    try {
      int index =
          userList.indexWhere((element) => element.id == userSelected.id);
      userList[index] = userSelected.copyWith(selected: selected);
      state = UserStateLoadSuccess(userList);
    } catch (e) {
      state = UserStateError(e.toString());
    }
  }
}
