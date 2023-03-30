import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../provider/home_controller.dart';
import '../../model/category_model.dart';
import '../../provider/auth_controller.dart';
import '../../provider/category_controller.dart';
import '../../utils.dart';

class CatChoiceChipList extends ConsumerWidget {
  const CatChoiceChipList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.read(authRepositoryProvider).getUser!.uid;
    return StreamBuilder(
        stream: ref.read(catRepositoryProvider).load(uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox.shrink();
          }
          if (snapshot.error != null) {
            return Center(child: Text('someErrorOccurred'.tr()));
          }
          return Consumer(builder: ((context, ref, child) {
            List<Category> catList = snapshot.data as List<Category>;
            if (catList.isNotEmpty) {
              ref.read(catListProvider.notifier).state.addAll(catList);
              catList.sort((a, b) => a.index.compareTo(b.index));
            }

            return CatChoiceChipItem(catList: catList);
          }));
        });
  }
}

class CatChoiceChipItem extends ConsumerWidget {
  const CatChoiceChipItem({required this.catList, Key? key}) : super(key: key);
  final List<Category> catList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var index = ref.watch(indexCatProvider);
    return SizedBox(
        height: buttonHeight,
        width: MediaQuery.of(context).size.width * 0.8,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: catList.length,
            shrinkWrap: true,
            itemBuilder: ((context, i) {
              return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                  child: ChoiceChip(
                    selectedColor: Theme.of(context).colorScheme.primary,
                    elevation: 1,
                    labelPadding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                    label: Text(
                      catList[i].categoryName,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontSize: 14),
                    ),
                    selected: index == i,
                    onSelected: (selected) {
                      ref.read(indexCatProvider.notifier).state =
                          (index = selected ? i : null);
                    },
                  ));
            })));
  }
}
