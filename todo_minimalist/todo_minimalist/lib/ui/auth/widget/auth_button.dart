import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../provider/auth_controller.dart';
import '../../../provider/states/auth_state.dart';
import '../../../utils.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    required this.title,
    required this.onPressed,
    super.key,
  });
  final String title;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: ((context, ref, child) {
        final state = ref.watch(authControllerProvider);
        return SizedBox(
          height: buttonHeight,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // <-- Radius
              ),
            ),
            onPressed: state is AuthStateLoading ? null : onPressed,
            child: Text(title),
          ),
        );
      }),
    );
  }
}
