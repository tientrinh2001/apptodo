import 'package:hooks_riverpod/hooks_riverpod.dart';

final tabControllerProvider = StateNotifierProvider<TabController, int>((_) {
  return TabController();
});

class TabController extends StateNotifier<int> {
  TabController() : super(0);

  changePage(int newIndex) {
    state = newIndex;
  }
}
