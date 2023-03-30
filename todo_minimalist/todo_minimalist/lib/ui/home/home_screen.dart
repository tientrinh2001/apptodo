import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../enum.dart';
import '../../model/category_model.dart';
import '../../provider/auth_controller.dart';
import '../../provider/category_controller.dart';
import '../../provider/home_controller.dart';
import '../../provider/project_controller.dart';
import '../../provider/states/category_state.dart';
import '../../provider/states/project_state.dart';
import '../../provider/states/todo_state.dart';
import '../../provider/tab_controller.dart';
import '../../provider/todo_controller.dart';
import '../../utils.dart';
import '../category/category_dialog.dart';
import '../project/project_dialog.dart';
import '../widget/snack_bar.dart';
import 'widget/home_form.dart';
import 'widget/home_popup_menu.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final uid = ref.read(authRepositoryProvider).getUser!.uid;
    final dateSelected = ref.watch(homeDateControllerProvider);
    final tabIndex = ref.watch(tabControllerProvider);
    ref.listen<TodoState>(todoControllerProvider, ((previous, state) {
      if (state is TodoAttachStateSuccess) {
        showSnackBar(context, 'success'.tr());
      } else if (state is TodoDeleteSuccess) {
        Navigator.pop(context);
        showSnackBar(context, 'success'.tr());
      }
    }));
    ref.listen<CategoryState>(catControllerProvider, ((_, state) {
      if (state is CategoryStateError) {
        showSnackBar(context, state.error);
      } else if (state is CategoryCreateSuccess ||
          state is CategoryUpdateSuccess ||
          state is CategoryDeleteSuccess) {
        Navigator.pop(context);
        showSnackBar(context, 'success'.tr());
      }
    }));
    ref.listen<ProjectState>(projectControllerProvider, ((_, state) {
      if (state is ProjectStateError) {
        showSnackBar(context, state.error);
      } else if (state is ProjectCreateSuccess ||
          state is ProjectUpdateSuccess ||
          state is ProjectAddSuccess) {
        Navigator.pop(context);
        showSnackBar(context, 'success'.tr());
      }
    }));

    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            title: const Text('Todo List'),
            actions: const [
              HomePopupMenu(),
            ],
          ),
          body: StreamBuilder(
              stream: ref.read(catRepositoryProvider).load(uid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox.shrink();
                }
                if (snapshot.error != null) {
                  return Center(child: Text('someErrorOccurred'.tr()));
                }
                List<Category> catList = snapshot.data as List<Category>;
                if (catList.isNotEmpty) {
                  catList.sort((a, b) => a.index.compareTo(b.index));
                }
                return HomeForm(
                  selectedPageIndex: tabIndex,
                  date: dateSelected,
                  catList: catList,
                );
              }),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: tabIndex,
            onTap: (index) {
              ref.read(tabControllerProvider.notifier).changePage(index);
            },
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: todoIcon,
                label: 'todo'.tr(),
              ),
              BottomNavigationBarItem(
                icon: dateIcon,
                label: 'calendar'.tr(),
              ),
              BottomNavigationBarItem(
                icon: catIcon,
                label: 'category'.tr(),
              ),
              BottomNavigationBarItem(
                icon: projectIcon,
                label: 'project'.tr(),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: (() async {
              if (tabIndex == 0 || tabIndex == 1) {
                Navigator.pushNamed(context, '/todo',
                    arguments: {'todo': null});
              } else if (tabIndex == 2) {
                await createOrUpdateCategory(context, CatAction.create, null);
              } else if (tabIndex == 3) {
                await createOrUpdateProject(
                    context, ProjectAction.create, null, ref);
              }
            }),
            child: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ));
  }
}
