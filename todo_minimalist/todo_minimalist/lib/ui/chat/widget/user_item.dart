import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../model/user_model.dart';

class UserItem extends ConsumerWidget {
  const UserItem({required this.user, Key? key}) : super(key: key);
  final User user;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.grey,
        ),
        child: ListTile(
          leading: const Icon(Icons.account_circle),
          title: Text(user.displayName!),
          subtitle: Text(user.email),
          trailing: const Icon(Icons.more_vert),
        ),
      ),
    );
  }
}
