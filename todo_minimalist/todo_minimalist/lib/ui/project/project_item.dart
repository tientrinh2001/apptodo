import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../utils.dart';
import '../../../model/project_model.dart';
import '../../core/theme.dart';
import 'project_popup_menu.dart';

class ProjectItem extends ConsumerWidget {
  const ProjectItem({required this.project, Key? key}) : super(key: key);
  final Project project;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/task', arguments: {'project': project});
      },
      child: Card(
        color: project.color,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(project.name, style: titleStyle),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      if (project.member.isNotEmpty) ...[
                        for (int i = 0; i < project.member.length; i++) ...[
                          const Icon(Icons.account_circle, color: Colors.white)
                        ]
                      ] else ...[
                        const SizedBox.shrink(),
                      ]
                    ]),
                    ProjectPopupMenu(project: project),
                  ],
                ),
                Text(dateFormat.format(project.createdDateTime.toDate()))
              ],
            )),
      ),
    );
  }
}
