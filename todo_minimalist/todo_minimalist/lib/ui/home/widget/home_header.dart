import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../category/category_listview.dart';

class Header extends ConsumerWidget {
  const Header({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const CatListView();
  }
}
