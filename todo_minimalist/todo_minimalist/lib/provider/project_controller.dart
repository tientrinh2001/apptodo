import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/project_model.dart';
import '../model/user_model.dart';
import '../repository/project_repository.dart';
import 'auth_controller.dart';
import 'states/project_state.dart';

final projectRepositoryProvider = Provider.autoDispose<ProjectRepository>(
    (ref) => ProjectRepository(ref, FirebaseFirestore.instance));

final projectControllerProvider =
    StateNotifierProvider.autoDispose<ProjectController, ProjectState>(
        (ref) => ProjectController(ref));

class ProjectController extends StateNotifier<ProjectState> {
  ProjectController(this.ref) : super(const ProjectStateInitial());
  final Ref ref;

  Future<void> create(String name, Color color) async {
    state = const ProjectStateLoading();
    try {
      final uid = ref.watch(authRepositoryProvider).getUser!.uid;
      if (name.isEmpty) {
        state = ProjectStateError('folderNotEmpty'.tr());
      } else {
        var newProject =
            Project.newProject(userId: uid, name: name, color: color);
        await ref.read(projectRepositoryProvider).create(newProject);
        state = const ProjectCreateSuccess();
      }
    } catch (e) {
      state = ProjectStateError(e.toString());
    }
  }

  Future<void> update(String name, Color color) async {
    state = const ProjectStateLoading();
    try {
      final uid = ref.watch(authRepositoryProvider).getUser!.uid;
      if (name.isEmpty) {
        state = ProjectStateError('folderNotEmpty'.tr());
      } else {
        var newProject =
            Project.newProject(userId: uid, name: name, color: color);
        await ref.read(projectRepositoryProvider).create(newProject);
        state = const ProjectUpdateSuccess();
      }
    } catch (e) {
      state = ProjectStateError(e.toString());
    }
  }

  Future<void> addMember(Project project, List<User> userSelectList) async {
    try {
      if (userSelectList.isNotEmpty) {
        List<User> memberList = project.member;
        memberList.addAll(userSelectList);
        Project newProject = project.addMember(memberList);
        await ref.read(projectRepositoryProvider).update(newProject);
        state = const ProjectAddSuccess();
      }
    } catch (e) {
      state = ProjectStateError(e.toString());
    }
  }
}
