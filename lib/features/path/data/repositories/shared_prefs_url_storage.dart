import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/url_storage.dart';

class SharedPrefsUrlStorage implements UrlStorage {
  SharedPrefsUrlStorage(this._prefs);

  static const String _key = 'api_url';

  final SharedPreferences _prefs;

  @override
  String? read() => _prefs.getString(_key) ?? UrlStorage.defaultUrl;

  @override
  Future<void> save(String url) => _prefs.setString(_key, url);
}
