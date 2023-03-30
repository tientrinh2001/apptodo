import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../provider/auth_controller.dart';
import '../../../provider/auth_form_controller.dart';
import '../../widget/custom_text_form_field.dart';
import 'auth_button.dart';

class SignInForm extends ConsumerWidget {
  const SignInForm({
    required this.emailTextEditingController,
    required this.passwordTextEditingController,
    Key? key,
  }) : super(key: key);
  final TextEditingController emailTextEditingController;
  final TextEditingController passwordTextEditingController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const SizedBox(height: 25),
        CustomTextFormField(
          controller: emailTextEditingController,
          keyboardType: TextInputType.emailAddress,
          hintText: 'email'.tr(),
          icon: const Icon(Icons.email),
        ),
        const SizedBox(height: 10),
        CustomTextFormField(
          controller: passwordTextEditingController,
          keyboardType: TextInputType.emailAddress,
          hintText: 'password'.tr(),
          icon: const Icon(Icons.lock),
          obscureText: true,
        ),
        const SizedBox(height: 25),
        AuthButton(
            title: 'signIn'.tr(),
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).signIn(
                  emailTextEditingController.text,
                  passwordTextEditingController.text);
            }),
        const SizedBox(height: 25),
        AuthButton(
            title: 'Google',
            onPressed: () async {
              await ref
                  .read(authControllerProvider.notifier)
                  .signInWithGoogle();
            }),
        const SizedBox(height: 25),
        InkWell(
            onTap: () {
              ref.read(authFormControllerProvider.notifier).switchSignUpForm();
            },
            child: Text('iHaveNoAccount'.tr())),
        const SizedBox(height: 25),
        InkWell(
            onTap: () {
              ref
                  .read(authFormControllerProvider.notifier)
                  .switchResetPasswordForm();
            },
            child: Text('resetPassword'.tr())),
        const SizedBox(height: 25),
      ],
    );
  }
}
