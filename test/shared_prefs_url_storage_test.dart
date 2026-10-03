import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shortest_path_app/features/path/data/repositories/shared_prefs_url_storage.dart';
import 'package:shortest_path_app/features/path/domain/repositories/url_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('returns the default URL when no URL has been saved', () async {
    SharedPreferences.setMockInitialValues({});
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final SharedPrefsUrlStorage storage = SharedPrefsUrlStorage(preferences);

    expect(storage.read(), UrlStorage.defaultUrl);
  });

  test('returns the saved URL instead of the default URL', () async {
    SharedPreferences.setMockInitialValues({'api_url': 'https://example.com'});
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final SharedPrefsUrlStorage storage = SharedPrefsUrlStorage(preferences);

    expect(storage.read(), 'https://example.com');
  });

  test('saves a custom URL for the next read', () async {
    SharedPreferences.setMockInitialValues({});
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final SharedPrefsUrlStorage storage = SharedPrefsUrlStorage(preferences);

    await storage.save('https://example.com');

    expect(storage.read(), 'https://example.com');
  });
}
