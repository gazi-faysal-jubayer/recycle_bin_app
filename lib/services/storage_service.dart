import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';

class StorageService {
  // Save auth token
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.tokenKey, token);
  }
  
  // Get auth token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.tokenKey);
  }
  
  // Delete auth token
  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenKey);
  }
  
  // Save user ID
  Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.userIdKey, userId);
  }
  
  // Get user ID
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.userIdKey);
  }
  
  // Delete user ID
  Future<void> deleteUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.userIdKey);
  }
  
  // Save app settings
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    final prefs = await SharedPreferences.getInstance();
    for (final entry in settings.entries) {
      if (entry.value is String) {
        await prefs.setString(entry.key, entry.value);
      } else if (entry.value is bool) {
        await prefs.setBool(entry.key, entry.value);
      } else if (entry.value is int) {
        await prefs.setInt(entry.key, entry.value);
      } else if (entry.value is double) {
        await prefs.setDouble(entry.key, entry.value);
      }
    }
  }
  
  // Get app settings
  Future<Map<String, dynamic>> getSettings(List<String> keys) async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> settings = {};
    
    for (final key in keys) {
      settings[key] = prefs.get(key);
    }
    
    return settings;
  }
}