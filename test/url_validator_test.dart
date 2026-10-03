import 'package:flutter_test/flutter_test.dart';
import 'package:shortest_path_app/core/utils/url_validator.dart';

void main() {
  test('accepts http(s) URLs, including query parameters', () {
    expect(
      UrlValidator.validate('https://flutter.webspark.dev/flutter/api'),
      isNull,
    );
    expect(UrlValidator.validate('http://10.0.2.2:8080/api?a=1&b=2'), isNull);
    expect(UrlValidator.validate('  https://example.com  '), isNull);
  });

  test('rejects invalid input', () {
    expect(UrlValidator.validate(null), isNotNull);
    expect(UrlValidator.validate(''), isNotNull);
    expect(UrlValidator.validate('example.com'), isNotNull);
    expect(UrlValidator.validate('ftp://example.com'), isNotNull);
    expect(UrlValidator.validate('https://'), isNotNull);
    expect(UrlValidator.validate('not a url'), isNotNull);
  });
}
