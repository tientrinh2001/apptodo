import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../provider/auth_form_controller.dart';
import '../../../provider/states/auth_form_state.dart';
import 'reset_password_form.dart';
import 'sign_in_form.dart';
import 'sign_up_form.dart';

class AuthForm extends ConsumerStatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  ConsumerState<AuthForm> createState() => _BodyState();
}

class _BodyState extends ConsumerState<AuthForm> {
  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  final displayNamePasswordTextEditingController = TextEditingController();

  @override
  void dispose() {
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    displayNamePasswordTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Center(
          child: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Todo minimalist",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                fontFamily: GoogleFonts.chakraPetch().fontFamily,
              ),
            ),
            const SizedBox(height: 30),
            Consumer(builder: ((context, ref, child) {
              final state = ref.watch(authFormControllerProvider);
              if (state is SwitchSignUpForm) {
                return SignUpForm(
                  emailTextEditingController: emailTextEditingController,
                  passwordTextEditingController: passwordTextEditingController,
                  displayNamePasswordTextEditingController:
                      displayNamePasswordTextEditingController,
                );
              } else if (state is SwitchResetPasswordForm) {
                return ResetPasswordForm(
                  emailTextEditingController: emailTextEditingController,
                );
              }
              return SignInForm(
                emailTextEditingController: emailTextEditingController,
                passwordTextEditingController: passwordTextEditingController,
              );
            })),
          ],
        )),
      )),
    );
  }
}
