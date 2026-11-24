/// Text and files another app shared into Githeft.
class SharedContent {
  SharedContent({this.text = '', this.subject = '', this.files = const []});

  factory SharedContent.fromMap(Map<Object?, Object?> m) => SharedContent(
    text: (m['text'] as String?) ?? '',
    subject: (m['subject'] as String?) ?? '',
    files: [for (final f in (m['files'] as List<Object?>?) ?? const []) f as String],
  );

  final String text;
  final String subject;

  /// Copies of the shared files in the app's cache.
  final List<String> files;

  bool get isEmpty => text.trim().isEmpty && subject.trim().isEmpty && files.isEmpty;
}
