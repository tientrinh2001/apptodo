import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../provider/auth_controller.dart';
import '../../../provider/auth_form_controller.dart';
import '../../widget/custom_text_form_field.dart';
import 'auth_button.dart';

class ResetPasswordForm extends ConsumerWidget {
  const ResetPasswordForm({
    required this.emailTextEditingController,
    Key? key,
  }) : super(key: key);
  final TextEditingController emailTextEditingController;

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
        const SizedBox(height: 25),
        AuthButton(
          title: 'resetPassword'.tr(),
          onPressed: () async {
            await ref
                .read(authControllerProvider.notifier)
                .resetPassword(emailTextEditingController.text);
          },
        ),
        const SizedBox(height: 25),
        InkWell(
          onTap: () {
            ref.read(authFormControllerProvider.notifier).switchSignInForm();
          },
          child: Text(
            'goToSignIn'.tr(),
          ),
        ),
        const SizedBox(height: 25),
      ],
    );
  }
}
