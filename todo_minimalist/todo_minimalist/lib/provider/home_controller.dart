import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../utils.dart';

final indexCatProvider = StateProvider<int?>((ref) {
  return 0;
});

final homeControllerProvider =
    StateNotifierProvider.autoDispose<HomeController, WidgetType>((_) {
  return HomeController();
});

final homeDateControllerProvider =
    StateNotifierProvider<HomeDateController, String>((_) {
  return HomeDateController();
});

class HomeController extends StateNotifier<WidgetType> {
  HomeController()
      : super(WidgetType(
          crossAxisCount: 1,
          childAspectRatio: 3 / 1,
          name: 'girdView'.tr(),
          code: 'listView',
          icon: Icons.grid_on,
        ));

  changeWidgetType(WidgetType widgetType) {
    if (widgetType.code == 'girdView') {
      state = WidgetType(
        crossAxisCount: 1,
        childAspectRatio: 3 / 1,
        name: 'girdView'.tr(),
        code: 'listView',
        icon: Icons.grid_on,
      );
    } else {
      state = WidgetType(
        crossAxisCount: 2,
        childAspectRatio: 3 / 3,
        name: 'listView'.tr(),
        code: 'girdView',
        icon: Icons.list,
      );
    }
  }
}

class HomeDateController extends StateNotifier<String> {
  HomeDateController() : super(dateFormat.format(DateTime.now()));

  changeDate(String newDate) {
    state = newDate;
  }
}

class WidgetType {
  int crossAxisCount;
  double childAspectRatio;
  String name;
  String code;
  IconData icon;
  WidgetType({
    required this.crossAxisCount,
    required this.childAspectRatio,
    required this.name,
    required this.code,
    required this.icon,
  });
}
