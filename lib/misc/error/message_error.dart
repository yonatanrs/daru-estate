class MessageError extends Error {
  final String title;
  final String message;

  MessageError({this.title = "", this.message = ""});

  @override
  String toString() {
    return '$title: $message';
  }
}