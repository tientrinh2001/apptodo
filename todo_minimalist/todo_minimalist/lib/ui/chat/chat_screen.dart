import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:uuid/uuid.dart';

import '../../model/project_model.dart';
import '../../provider/auth_controller.dart';
import '../../provider/chat_controller.dart';
import '../../provider/states/chat_state.dart';
import 'widget/chat_popup_menu.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ProgressDialog pd = ProgressDialog(context: context);

    ref.listen<ChatState>(chatControllerProvider, ((previous, state) {
      if (state is ChatUploading) {
        pd.show(
          max: 100,
          msg: state.mgs,
          msgColor: Theme.of(context).colorScheme.background,
          msgFontWeight: FontWeight.normal,
        );
      } else if (state is ChatUploadSuccess) {
        pd.close(delay: 1000);
      } else if (state is ChatDownloading) {
        pd.show(
          max: 100,
          msg: state.mgs,
          msgColor: Theme.of(context).colorScheme.background,
          msgFontWeight: FontWeight.normal,
        );
      } else if (state is ChatDownloadSuccess) {
        pd.close(delay: 1000);
      }
    }));
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final uid = ref.watch(authRepositoryProvider).getUser!.uid;
    final project = args['project'] as Project;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Trò chuyện'),
          actions: [
            ChatPopupMenu(project: project),
          ],
        ),
        body: StreamBuilder(
          stream: ref.read(chatRepositoryProvider).load(project.chatId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.error != null) {
              return Center(child: Text('someErrorOccurred'.tr()));
            }
            var chatList = snapshot.data as List<types.Message>;
            if (chatList.isNotEmpty) {
              chatList.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
            }
            return Chat(
              dateLocale: context.locale.languageCode,
              dateHeaderThreshold: 1000,
              messages: chatList,
              user: types.User(id: uid),
              onSendPressed: (value) async {
                await _handleTextInput(value, ref, project);
              },
              showUserAvatars: true,
              showUserNames: true,
              theme: DefaultChatTheme(
                  backgroundColor: Theme.of(context).backgroundColor),
              bubbleRtlAlignment: BubbleRtlAlignment.left,
              onAttachmentPressed: () {
                _handleAttachmentPressed(context, uid, ref, project);
              },
              onMessageLongPress: (context, message) {
                _onMessageLongPress(context, uid, ref, project, message);
              },
              l10n: const ChatL10nEn(inputPlaceholder: 'Tin nhắn'),
            );
          },
        ));
  }

  Future<void> _handleTextInput(
    types.PartialText text,
    WidgetRef ref,
    Project project,
  ) async {
    final user = ref.watch(authRepositoryProvider).getUser!;
    var message = types.TextMessage(
      id: const Uuid().v4(),
      author: types.User(
        id: user.uid,
        lastName: user.displayName,
      ),
      roomId: project.chatId,
      text: text.text,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    await ref
        .read(chatControllerProvider.notifier)
        .create(message, text.text, project);
  }

  Future<void> _handleImageSelection(WidgetRef ref, Project project) async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );
    if (result != null) {
      await ref
          .read(chatControllerProvider.notifier)
          .uploadImage(result, project);
    }
  }

  Future<void> _handleFileSelection(WidgetRef ref, Project project) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );
    if (result!.files.isNotEmpty) {
      await ref
          .read(chatControllerProvider.notifier)
          .uploadFile(result, project);
    }
  }

  void _onMessageLongPress(BuildContext context, String uid, WidgetRef ref,
      Project project, types.Message message) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await ref
                      .read(chatControllerProvider.notifier)
                      .download(message);
                },
                child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Row(
                      children: const [
                        Icon(Icons.download),
                        SizedBox(width: 20),
                        Text('Tải xuống'),
                      ],
                    )),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Row(
                    children: const [
                      Icon(Icons.close),
                      SizedBox(width: 20),
                      Text('Đóng'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleAttachmentPressed(
      BuildContext context, String uid, WidgetRef ref, Project project) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await _handleImageSelection(ref, project);
                },
                child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Row(
                      children: const [
                        Icon(Icons.image),
                        SizedBox(width: 20),
                        Text('Hình'),
                      ],
                    )),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await _handleFileSelection(ref, project);
                },
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Row(
                    children: const [
                      Icon(Icons.file_copy),
                      SizedBox(width: 20),
                      Text('File'),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Row(
                    children: const [
                      Icon(Icons.close),
                      SizedBox(width: 20),
                      Text('Huỷ'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
