class ProjectState {
  const ProjectState();
}

class ProjectStateInitial extends ProjectState {
  const ProjectStateInitial() : super();
}

class ProjectStateLoading extends ProjectState {
  const ProjectStateLoading();
}

class ProjectStateSuccess extends ProjectState {
  const ProjectStateSuccess();
}

class ProjectUpdateSuccess extends ProjectState {
  const ProjectUpdateSuccess();
}

class ProjectCreateSuccess extends ProjectState {
  const ProjectCreateSuccess();
}

class ProjectDeleteSuccess extends ProjectState {
  const ProjectDeleteSuccess();
}

class ProjectAddSuccess extends ProjectState {
  const ProjectAddSuccess();
}

class ProjectStateError extends ProjectState {
  final String error;

  const ProjectStateError(this.error);
}
