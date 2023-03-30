import '../../model/project_model.dart';
import '../../model/user_model.dart';

class UserState {
  const UserState();
}

class UserStateInitial extends UserState {
  const UserStateInitial();
}

class UserStateLoading extends UserState {
  const UserStateLoading();
}

class UserStateOpenProjectSheet extends UserState {
  final Project project;
  const UserStateOpenProjectSheet(this.project);
}

class UserStateOpenTaskSheet extends UserState {
  final Project project;
  const UserStateOpenTaskSheet(this.project);
}

class UserStateSuccess extends UserState {
  const UserStateSuccess();
}

class UserStateLoadSuccess extends UserState {
  final List<User> user;
  const UserStateLoadSuccess(this.user);
}

class UserStateError extends UserState {
  final String error;

  const UserStateError(this.error);
}
