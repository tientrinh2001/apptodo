import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../provider/auth_controller.dart';
import '../../../provider/home_controller.dart';

class HomePopupMenu extends ConsumerWidget {
  const HomePopupMenu({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeController = ref.watch(homeControllerProvider);
    return PopupMenuButton(
        itemBuilder: (_) {
          return [
            PopupMenuItem(
              value: null,
              child: Row(
                children: [
                  Icon(
                    homeController.icon,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    homeController.name,
                  ),
                ],
              ),
              onTap: () {
                ref
                    .read(homeControllerProvider.notifier)
                    .changeWidgetType(homeController);
              },
            ),
            PopupMenuItem(
                value: null,
                onTap: () async {
                  await ref.read(authControllerProvider.notifier).signOut();
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 10),
                    Text('logout'.tr()),
                  ],
                )),
          ];
        },
        icon: const Icon(Icons.more_vert));
  }
}
