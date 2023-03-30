import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../repository/auth_repository.dart';
import 'states/auth_state.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(FirebaseAuth.instance, ref);
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.read(authRepositoryProvider).authStateChange;
});

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref);
});

class AuthController extends StateNotifier<AuthState> {
  AuthController(this.ref) : super(const AuthStateInitial());

  final Ref ref;

  Future<void> signIn(String email, String password) async {
    state = const AuthStateLoading();
    try {
      if (email.isEmpty || password.isEmpty) {
        state = AuthStateError('emailAndPassNotEmpty'.tr());
      } else {
        await ref.read(authRepositoryProvider).signInWithEmailAndPassword(
              email,
              password,
            );
        state = const AuthStateSuccess();
      }
    } catch (e) {
      state = AuthStateError(e.toString());
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AuthStateLoading();
    try {
      await ref.read(authRepositoryProvider).signInWithGoogle();
      state = const AuthStateSuccess();
    } catch (e) {
      state = AuthStateError(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await ref.read(authRepositoryProvider).signOut();
    } catch (e) {
      state = AuthStateError(e.toString());
    }
  }

  Future<void> signUp(String email, String password, String displayName) async {
    state = const AuthStateLoading();
    try {
      if (email.isEmpty || password.isEmpty) {
        state = AuthStateError('emailAndPassNotEmpty'.tr());
      } else {
        await ref
            .read(authRepositoryProvider)
            .signUpWithEmailAndPassword(email, password, displayName);

        state = const AuthStateSuccess();
      }
    } catch (e) {
      state = AuthStateError(e.toString());
    }
  }

  Future<void> resetPassword(String email) async {
    state = const AuthStateLoading();
    try {
      if (email.isEmpty) {
        state = AuthStateError('emailNotEmpty'.tr());
      } else {
        await ref
            .read(authRepositoryProvider)
            .resetPasswordWithEmail(email.trim());
        state = const AuthResetPasswordSuccess();
      }
    } catch (e) {
      state = AuthStateError(e.toString());
    }
  }
}
