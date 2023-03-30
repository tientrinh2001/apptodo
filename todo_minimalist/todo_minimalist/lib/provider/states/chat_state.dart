class ChatState {
  const ChatState();
}

class ChatStateInitial extends ChatState {
  const ChatStateInitial() : super();
}

class ChatStateLoading extends ChatState {
  const ChatStateLoading();
}

class ChatUploading extends ChatState {
  final String mgs;
  const ChatUploading(this.mgs);
}

class ChatDownloading extends ChatState {
  final String mgs;
  const ChatDownloading(this.mgs);
}

class ChatDownloadSuccess extends ChatState {
  final String mgs;
  const ChatDownloadSuccess(this.mgs);
}

class ChatStateSuccess extends ChatState {
  const ChatStateSuccess();
}

class ChatUploadSuccess extends ChatState {
  final String mgs;
  const ChatUploadSuccess(this.mgs);
}

class ChatDeleteSuccess extends ChatState {
  const ChatDeleteSuccess();
}

class ChatStateError extends ChatState {
  final String error;

  const ChatStateError(this.error);
}
