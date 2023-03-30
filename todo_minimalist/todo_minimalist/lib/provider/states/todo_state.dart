class TodoState {
  const TodoState();
}

class TodoStateInitial extends TodoState {
  const TodoStateInitial();
}

class TodoStateLoading extends TodoState {
  const TodoStateLoading();
}

class TodoStateSuccess extends TodoState {
  const TodoStateSuccess();
}

class TodoDeleteSuccess extends TodoState {
  const TodoDeleteSuccess();
}

class TodoAttachStateSuccess extends TodoState {
  const TodoAttachStateSuccess();
}

class TodoStateError extends TodoState {
  final String error;

  const TodoStateError(this.error);
}
