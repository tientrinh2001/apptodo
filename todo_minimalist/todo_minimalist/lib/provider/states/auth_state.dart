class AuthState {
  const AuthState();
}

class AuthStateInitial extends AuthState {
  const AuthStateInitial();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateSuccess extends AuthState {
  const AuthStateSuccess();
}

class AuthResetPasswordSuccess extends AuthState {
  const AuthResetPasswordSuccess();
}

class AuthStateError extends AuthState {
  final String error;

  const AuthStateError(this.error);
}
