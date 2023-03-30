import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../model/project_model.dart';
import '../repository/chat_repository.dart';
import '../service/remote_notification_service.dart';
import 'auth_controller.dart';
import 'states/chat_state.dart';

final chatRepositoryProvider = Provider.autoDispose<ChatRepository>((ref) =>
    ChatRepository(ref, FirebaseFirestore.instance, FirebaseStorage.instance));

final chatControllerProvider =
    StateNotifierProvider.autoDispose<ChatController, ChatState>(
        (ref) => ChatController(ref));

class ChatController extends StateNotifier<ChatState> {
  ChatController(this.ref) : super(const ChatStateInitial());
  final Ref ref;

  Future<void> create(
      types.Message message, String text, Project project) async {
    try {
      var user = ref.watch(authRepositoryProvider).getUser!;
      await ref.read(chatRepositoryProvider).create(message);
      await ref
          .read(remoteNotificationServiceProvider)
          .push(project, text, user.uid);
    } catch (e) {
      state = ChatStateError(e.toString());
    }
  }

  Future<void> uploadImage(XFile? xFile, Project project) async {
    try {
      state = const ChatUploading('Đang tải hình');
      final bytes = await xFile!.readAsBytes();
      final image = await decodeImageFromList(bytes);
      var file = File(xFile.path);
      final user = ref.watch(authRepositoryProvider).getUser;
      var uri =
          await ref.read(chatRepositoryProvider).pushFile(file, project.chatId);
      final message = types.ImageMessage(
        author: types.User(
          id: user!.uid,
          lastName: user.displayName,
        ),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: xFile.name,
        size: bytes.length,
        uri: uri,
        width: image.width.toDouble(),
        roomId: project.chatId,
      );
      await ref
          .read(chatControllerProvider.notifier)
          .create(message, '${user.displayName} đã gửi 1 hình ảnh', project);
      state = const ChatUploadSuccess('Tải hình lên thành công');
    } catch (e) {
      state = ChatStateError(e.toString());
    }
  }

  Future<void> uploadFile(FilePickerResult xFile, Project project) async {
    try {
      state = const ChatUploading('Đang tải file');
      final user = ref.watch(authRepositoryProvider).getUser;
      for (var item in xFile.files) {
        var uri = await ref
            .read(chatRepositoryProvider)
            .pushFile(File(item.path!), project.chatId);
        if (xFile.files.single.path != null) {
          final message = types.FileMessage(
            author: types.User(
              id: user!.uid,
              lastName: user.displayName,
            ),
            createdAt: DateTime.now().millisecondsSinceEpoch,
            id: const Uuid().v4(),
            mimeType: xFile.files.single.path!,
            name: xFile.files.single.name,
            size: xFile.files.single.size,
            uri: uri,
            roomId: project.chatId,
          );

          await ref
              .read(chatControllerProvider.notifier)
              .create(message, '${user.displayName} đã gửi 1 file', project);
        }
      }
      state = const ChatUploadSuccess('Tải file lên thành công');
    } catch (e) {
      state = ChatStateError(e.toString());
    }
  }

  Future<void> download(types.Message message) async {
    try {
      state = const ChatDownloading('Đang tải');
      await ref.read(chatRepositoryProvider).downloadFile(message);
      state = const ChatDownloadSuccess('Tải xuống thành công');
    } catch (e) {
      state = ChatStateError(e.toString());
    }
  }
}
