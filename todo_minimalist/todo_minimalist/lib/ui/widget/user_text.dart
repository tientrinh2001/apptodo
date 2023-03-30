import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../model/user_model.dart';

import '../../provider/auth_controller.dart';
import '../../provider/user_controller.dart';

class UserText extends ConsumerWidget {
  const UserText({
    Key? key,
    required this.uid,
  }) : super(key: key);

  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authRepositoryProvider).getUser!.uid;
    return FutureBuilder(
        future: ref.read(userRepositoryProvider).getUser(uid),
        builder: ((context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox.shrink();
          }
          if (snapshot.error != null) {
            return Text('someErrorOccurred'.tr());
          }
          var user = snapshot.data as User;
          return currentUser != uid
              ? Text(user.displayName.toString())
              : const Text('tôi');
        }));
  }
}
