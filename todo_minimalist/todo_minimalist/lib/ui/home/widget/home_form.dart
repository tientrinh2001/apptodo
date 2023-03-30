import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_minimalist/provider/home_controller.dart';
import '../../../model/category_model.dart';
import '../../category/category_tab.dart';
import '../../project/project_tab.dart';
import '../../todo/widget/todo_tab.dart';
import 'calendar_tab.dart';
import 'date_picker_timeline.dart';
import 'home_content.dart';
import 'home_header.dart';

class HomeForm extends ConsumerWidget {
  const HomeForm({
    required this.selectedPageIndex,
    required this.date,
    required this.catList,
    Key? key,
  }) : super(key: key);
  final int selectedPageIndex;
  final String date;
  final List<Category>? catList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var index = ref.watch(indexCatProvider);
    List<Widget> pages = [
      catList!.isEmpty
          ? const SizedBox.shrink()
          : TodoTab(isDone: false, cat: catList![index!], date: date),
      const CalendarTab(),
      CategoryTab(catList: catList!),
      const ProjectTab(),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selectedPageIndex == 0) ...[
          DatePickerTimeLine(initialSelectedDate: DateTime.parse(date)),
          const Header(),
          const Divider(),
          Content(pages: pages, index: selectedPageIndex),
        ] else ...[
          Content(pages: pages, index: selectedPageIndex)
        ],
      ],
    );
  }
}
