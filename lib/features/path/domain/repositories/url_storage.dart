abstract class UrlStorage {
  static const String defaultUrl = 'https://flutter.webspark.dev/flutter/api';

  String? read();

  Future<void> save(String url);
}
