import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../provider/auth_controller.dart';
import '../../../provider/auth_form_controller.dart';
import '../../widget/custom_text_form_field.dart';
import 'auth_button.dart';

class SignUpForm extends ConsumerWidget {
  const SignUpForm({
    required this.emailTextEditingController,
    required this.passwordTextEditingController,
    required this.displayNamePasswordTextEditingController,
    Key? key,
  }) : super(key: key);
  final TextEditingController emailTextEditingController;
  final TextEditingController passwordTextEditingController;
  final TextEditingController displayNamePasswordTextEditingController;
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
          controller: displayNamePasswordTextEditingController,
          keyboardType: TextInputType.name,
          hintText: 'displayName'.tr(),
          icon: const Icon(Icons.account_circle),
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
            title: 'signUp'.tr(),
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).signUp(
                    emailTextEditingController.text,
                    passwordTextEditingController.text,
                    displayNamePasswordTextEditingController.text,
                  );
            }),
        const SizedBox(height: 25),
        InkWell(
            onTap: () {
              ref.read(authFormControllerProvider.notifier).switchSignInForm();
            },
            child: Text('iHaveAccount'.tr())),
        const SizedBox(height: 25),
      ],
    );
  }
}
