// Storage Service for local data persistence
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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

  // Complex object list operations
  Future<List<Map<String, dynamic>>?> getList(String key);
  Future<void> setList(String key, List<Map<String, dynamic>> value);

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

  SharedPreferences? _prefs;

  @override
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  @override
  Future<String?> getString(String key) async {
    await init();
    return _prefs?.getString(key);
  }

  @override
  Future<void> setString(String key, String value) async {
    await init();
    await _prefs?.setString(key, value);
  }

  @override
  Future<bool?> getBool(String key) async {
    await init();
    return _prefs?.getBool(key);
  }

  @override
  Future<void> setBool(String key, bool value) async {
    await init();
    await _prefs?.setBool(key, value);
  }

  @override
  Future<int?> getInt(String key) async {
    await init();
    return _prefs?.getInt(key);
  }

  @override
  Future<void> setInt(String key, int value) async {
    await init();
    await _prefs?.setInt(key, value);
  }

  @override
  Future<double?> getDouble(String key) async {
    await init();
    return _prefs?.getDouble(key);
  }

  @override
  Future<void> setDouble(String key, double value) async {
    await init();
    await _prefs?.setDouble(key, value);
  }

  @override
  Future<List<String>?> getStringList(String key) async {
    await init();
    return _prefs?.getStringList(key);
  }

  @override
  Future<void> setStringList(String key, List<String> value) async {
    await init();
    await _prefs?.setStringList(key, value);
  }

  @override
  Future<List<Map<String, dynamic>>?> getList(String key) async {
    await init();
    final jsonString = _prefs?.getString(key);
    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.cast<Map<String, dynamic>>();
      } catch (e) {
        print('Error parsing JSON list: $e');
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> setList(String key, List<Map<String, dynamic>> value) async {
    await init();
    final jsonString = json.encode(value);
    await _prefs?.setString(key, jsonString);
  }

  @override
  Future<void> remove(String key) async {
    await init();
    await _prefs?.remove(key);
  }

  @override
  Future<void> clear() async {
    await init();
    await _prefs?.clear();
  }

  @override
  Future<bool> containsKey(String key) async {
    await init();
    return _prefs?.containsKey(key) ?? false;
  }
}

// Global storage instance
class AppStorage {
  static final StorageService _storage = SharedPreferencesService.instance;

  static Future<String?> getString(String key) => _storage.getString(key);
  static Future<void> setString(String key, String value) =>
      _storage.setString(key, value);
  static Future<bool?> getBool(String key) => _storage.getBool(key);
  static Future<void> setBool(String key, bool value) =>
      _storage.setBool(key, value);
  static Future<int?> getInt(String key) => _storage.getInt(key);
  static Future<void> setInt(String key, int value) =>
      _storage.setInt(key, value);
  static Future<double?> getDouble(String key) => _storage.getDouble(key);
  static Future<void> setDouble(String key, double value) =>
      _storage.setDouble(key, value);
  static Future<List<String>?> getStringList(String key) =>
      _storage.getStringList(key);
  static Future<void> setStringList(String key, List<String> value) =>
      _storage.setStringList(key, value);
  static Future<List<Map<String, dynamic>>?> getList(String key) =>
      _storage.getList(key);
  static Future<void> setList(String key, List<Map<String, dynamic>> value) =>
      _storage.setList(key, value);
  static Future<void> remove(String key) => _storage.remove(key);
  static Future<void> clear() => _storage.clear();
  static Future<bool> containsKey(String key) => _storage.containsKey(key);
}
