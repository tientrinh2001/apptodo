import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'states/auth_form_state.dart';

final authFormControllerProvider =
    StateNotifierProvider.autoDispose<AuthFormController, AuthFormState>((_) {
  return AuthFormController();
});

class AuthFormController extends StateNotifier<AuthFormState> {
  AuthFormController() : super(const SwitchSignInForm());

  switchSignInForm() {
    state = const SwitchSignInForm();
  }

  switchSignUpForm() {
    state = const SwitchSignUpForm();
  }

  switchResetPasswordForm() {
    state = const SwitchResetPasswordForm();
  }
}
