import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../provider/user_controller.dart';
import '../service/remote_notification_service.dart';

class AuthRepository {
  final FirebaseAuth _auth;
  final Ref ref;
  const AuthRepository(this._auth, this.ref);

  Stream<User?> get authStateChange => _auth.idTokenChanges();

  User? get getUser => _auth.currentUser;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException('userNotFound'.tr());
      } else if (e.code == 'wrong-password') {
        throw AuthException('wrongPassword'.tr());
      } else if (e.code == 'invalid-email') {
        throw AuthException('invalidEmail'.tr());
      } else if (e.code == 'user-disabled') {
        throw AuthException('userDisabled'.tr());
      } else {
        throw AuthException('someErrorOccurred'.tr());
      }
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      var userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      await ref.read(userControllerProvider.notifier).create();
      await ref
          .read(remoteNotificationServiceProvider)
          .registration(userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException('userNotFound'.tr());
      } else if (e.code == 'wrong-password') {
        throw AuthException('wrongPassword'.tr());
      } else if (e.code == 'invalid-email') {
        throw AuthException('invalidEmail'.tr());
      } else if (e.code == 'user-disabled') {
        throw AuthException('userDisabled'.tr());
      } else {
        throw AuthException('someErrorOccurred'.tr());
      }
    }
  }

  Future<void> signUpWithEmailAndPassword(
      String email, String password, displayName) async {
    try {
      var userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await userCredential.user!.updateDisplayName(displayName);
      await ref.read(userControllerProvider.notifier).create();
      await ref
          .read(remoteNotificationServiceProvider)
          .registration(userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw AuthException('emailAlreadyInUse'.tr());
      } else if (e.code == 'invalid-email') {
        throw AuthException('invalidEmail'.tr());
      } else if (e.code == 'operation-not-allowed') {
        throw AuthException('operationNotAllowed'.tr());
      } else if (e.code == 'weak-password') {
        throw AuthException('weakPassword'.tr());
      } else {
        throw AuthException('someErrorOccurred'.tr());
      }
    }
  }

  Future<void> resetPasswordWithEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        throw AuthException('invalidEmail'.tr());
      } else if (e.code == 'user-not-found') {
        throw AuthException('userNotFound'.tr());
      } else {
        throw AuthException('someErrorOccurred'.tr());
      }
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() {
    return message;
  }
}
