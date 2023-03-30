class TaskState {
  const TaskState();
}

class TaskStateInitial extends TaskState {
  const TaskStateInitial() : super();
}

class TaskStateLoading extends TaskState {
  const TaskStateLoading();
}

class TaskStateSuccess extends TaskState {
  const TaskStateSuccess();
}

class TaskUpdateSuccess extends TaskState {
  const TaskUpdateSuccess();
}

class TaskCreateSuccess extends TaskState {
  const TaskCreateSuccess();
}

class TaskDeleteSuccess extends TaskState {
  const TaskDeleteSuccess();
}

class TaskStateError extends TaskState {
  final String error;

  const TaskStateError(this.error);
}
