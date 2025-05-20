import '../core/constants/app_constants.dart';
import '../models/user.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  User? _currentUser;
  
  User? get currentUser => _currentUser;
  
  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _storageService.getToken();
    return token != null && token.isNotEmpty;
  }
  
  // Login
  Future<User> login(String email, String password) async {
    try {
      final data = await _apiService.post(
        AppConstants.loginEndpoint,
        {'email': email, 'password': password},
      );
      
      // Save auth token
      await _storageService.saveToken(data['token']);
      await _storageService.saveUserId(data['user']['id']);
      
      // Update current user
      _currentUser = User.fromJson(data['user']);
      return _currentUser!;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
  
  // Register
  Future<User> register(String name, String email, String password) async {
    try {
      final data = await _apiService.post(
        AppConstants.registerEndpoint,
        {'name': name, 'email': email, 'password': password},
      );
      
      // Save auth token
      await _storageService.saveToken(data['token']);
      await _storageService.saveUserId(data['user']['id']);
      
      // Update current user
      _currentUser = User.fromJson(data['user']);
      return _currentUser!;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }
  
  // Logout
  Future<void> logout() async {
    await _storageService.deleteToken();
    await _storageService.deleteUserId();
    _currentUser = null;
  }
  
  // Get current user profile
  Future<User> getCurrentUser() async {
    if (_currentUser != null) return _currentUser!;
    
    try {
      final userId = await _storageService.getUserId();
      if (userId == null) throw Exception('No user ID found');
      
      final data = await _apiService.get('/users/$userId');
      _currentUser = User.fromJson(data);
      return _currentUser!;
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }
  
  // Update user profile
  Future<User> updateProfile(Map<String, dynamic> profileData) async {
    try {
      final userId = await _storageService.getUserId();
      if (userId == null) throw Exception('No user ID found');
      
      final data = await _apiService.put('/users/$userId', profileData);
      _currentUser = User.fromJson(data);
      return _currentUser!;
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
}