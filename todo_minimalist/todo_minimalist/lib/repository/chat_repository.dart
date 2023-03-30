import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ChatRepository {
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseStorage _firebaseStorage;
  final Ref ref;
  ChatRepository(this.ref, this._firebaseFirestore, this._firebaseStorage);

  static const String tableName = 'Chat';
  static const String roomIdCol = 'roomId';
  static const String createdAtCol = 'createdAt';

  late CollectionReference _chat;

  Stream<List<types.Message>> load(String roomId) async* {
    var snapshot1 = _firebaseFirestore
        .collection(tableName)
        .where(roomIdCol, isEqualTo: roomId)
        .snapshots();
    var result = snapshot1.map((event) =>
        event.docs.map((e) => types.Message.fromJson(e.data())).toList());
    yield* result;
  }

  Future<void> create(types.Message chat) async {
    _chat = _firebaseFirestore.collection(tableName);
    try {
      await _chat.add(chat.toJson());
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<String> pushFile(File xFile, String roomId) async {
    try {
      String fileName = xFile.path.split('/').last;
      var ref = _firebaseStorage.ref().child('$roomId$fileName');
      await ref.putData(await xFile.readAsBytes());
      return await ref.getDownloadURL();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> downloadFile(types.Message message) async {
    try {
      var ref = _firebaseStorage.ref();
      var httpsReference = getUrl(message);
      if (httpsReference != null) {
        final appDocDir = await getExternalStorageDirectory();
        final folderPath = Directory(join(appDocDir!.path, "download"));
        if (!await folderPath.exists()) {
          await folderPath.create(recursive: true);
        }
        final filePath = "${folderPath.path}/${httpsReference.fullPath}";
        final file = File(filePath);
        var downloadTask =
            await ref.child(httpsReference.fullPath).writeToFile(file);
        switch (downloadTask.state) {
          case TaskState.running:
            break;
          case TaskState.paused:
            break;
          case TaskState.success:
            break;
          case TaskState.canceled:
            break;
          case TaskState.error:
            break;
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Reference? getUrl(types.Message message) {
    if (message.type == types.MessageType.text) return null;
    if (message.type == types.MessageType.file) {
      return _firebaseStorage.refFromURL((message as types.FileMessage).uri);
    } else if (message.type == types.MessageType.image) {
      return _firebaseStorage.refFromURL((message as types.ImageMessage).uri);
    } else {
      return null;
    }
  }
}
