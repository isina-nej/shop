// Storage Service for local data persistence
abstract class StorageService {
  Future<void> init();

  // String operations
  Future<String?> getString(String key);
  Future<void> setString(String key, String value);

  // Boolean operations
  Future<bool?> getBool(String key);
  Future<void> setBool(String key, bool value);

  // Integer operations
  Future<int?> getInt(String key);
  Future<void> setInt(String key, int value);

  // Double operations
  Future<double?> getDouble(String key);
  Future<void> setDouble(String key, double value);

  // List operations
  Future<List<String>?> getStringList(String key);
  Future<void> setStringList(String key, List<String> value);

  // Remove operations
  Future<void> remove(String key);
  Future<void> clear();

  // Check if key exists
  Future<bool> containsKey(String key);
}

// Shared Preferences Implementation
class SharedPreferencesService implements StorageService {
  static SharedPreferencesService? _instance;
  static SharedPreferencesService get instance {
    _instance ??= SharedPreferencesService._();
    return _instance!;
  }

  SharedPreferencesService._();

  // TODO: Initialize SharedPreferences
  @override
  Future<void> init() async {
    // Implementation will be added when SharedPreferences dependency is added
  }

  @override
  Future<String?> getString(String key) async {
    // TODO: Implement
    return null;
  }

  @override
  Future<void> setString(String key, String value) async {
    // TODO: Implement
  }

  @override
  Future<bool?> getBool(String key) async {
    // TODO: Implement
    return null;
  }

  @override
  Future<void> setBool(String key, bool value) async {
    // TODO: Implement
  }

  @override
  Future<int?> getInt(String key) async {
    // TODO: Implement
    return null;
  }

  @override
  Future<void> setInt(String key, int value) async {
    // TODO: Implement
  }

  @override
  Future<double?> getDouble(String key) async {
    // TODO: Implement
    return null;
  }

  @override
  Future<void> setDouble(String key, double value) async {
    // TODO: Implement
  }

  @override
  Future<List<String>?> getStringList(String key) async {
    // TODO: Implement
    return null;
  }

  @override
  Future<void> setStringList(String key, List<String> value) async {
    // TODO: Implement
  }

  @override
  Future<void> remove(String key) async {
    // TODO: Implement
  }

  @override
  Future<void> clear() async {
    // TODO: Implement
  }

  @override
  Future<bool> containsKey(String key) async {
    // TODO: Implement
    return false;
  }
}
