import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../provider/auth_controller.dart';
import '../../provider/states/auth_state.dart';
import '../widget/snack_bar.dart';
import 'widget/auth_form.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AuthState>(authControllerProvider, ((previous, state) {
      if (state is AuthStateError) {
        showSnackBar(context, state.error);
      } else if (state is AuthResetPasswordSuccess) {
        showSnackBar(context, 'pleaseCheckEmail'.tr());
      }
    }));
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: const Scaffold(
          resizeToAvoidBottomInset: false,
          body: AuthForm(),
        ));
  }
}
