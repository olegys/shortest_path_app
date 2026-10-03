class UrlValidator {
  const UrlValidator._();

  static String? validate(String? value) {
    final String text = value?.trim() ?? '';

    if (text.isEmpty) return 'Please enter the API URL';

    final Uri? uri = Uri.tryParse(text);

    if (uri == null ||
        !(uri.scheme == 'http' || uri.scheme == 'https') ||
        uri.host.isEmpty) {
      return 'Enter a valid URL, e.g. https://example.com/api';
    }

    return null;
  }
}
