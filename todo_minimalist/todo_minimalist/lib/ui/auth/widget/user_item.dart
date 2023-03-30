import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../model/user_model.dart';
import '../../../provider/user_controller.dart';

class UserItem extends ConsumerWidget {
  const UserItem({
    required this.userList,
    required this.index,
    super.key,
  });
  final List<User> userList;
  final int index;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: Theme.of(context).colorScheme.primary,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: GFCheckboxListTile(
        titleText: userList[index].email,
        subTitleText: userList[index].displayName!,
        avatar: const Icon(Icons.account_circle),
        size: 25,
        activeBgColor: Colors.green,
        type: GFCheckboxType.circle,
        activeIcon: const Icon(
          Icons.check,
          size: 15,
          color: Colors.white,
        ),
        onChanged: (value) async {
          await ref
              .read(userControllerProvider.notifier)
              .select(userList, userList[index], value);
        },
        value: userList[index].selected!,
        inactiveIcon: null,
      ),
    );
  }
}
