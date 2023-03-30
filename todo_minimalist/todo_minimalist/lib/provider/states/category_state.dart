class CategoryState {
  const CategoryState();
}

class CategoryStateInitial extends CategoryState {
  const CategoryStateInitial();
}

class CategoryStateLoading extends CategoryState {
  const CategoryStateLoading();
}

class CategoryStateSuccess extends CategoryState {
  const CategoryStateSuccess();
}

class CategoryUpdateSuccess extends CategoryState {
  const CategoryUpdateSuccess();
}

class CategoryCreateSuccess extends CategoryState {
  const CategoryCreateSuccess();
}

class CategoryDeleteSuccess extends CategoryState {
  const CategoryDeleteSuccess();
}

class CategoryStateError extends CategoryState {
  final String error;

  const CategoryStateError(this.error);
}
