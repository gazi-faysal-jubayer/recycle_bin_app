import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/app_constants.dart';
import 'storage_service.dart';

class ApiService {
  final StorageService _storageService = StorageService();
  
  // Headers with authentication token
  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
  
  // GET request
  Future<dynamic> get(String endpoint) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}$endpoint'),
        headers: headers,
      );
      
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to perform GET request: $e');
    }
  }
  
  // POST request
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}$endpoint'),
        headers: headers,
        body: json.encode(data),
      );
      
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to perform POST request: $e');
    }
  }
  
  // PUT request
  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('${AppConstants.baseUrl}$endpoint'),
        headers: headers,
        body: json.encode(data),
      );
      
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to perform PUT request: $e');
    }
  }
  
  // DELETE request
  Future<dynamic> delete(String endpoint) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('${AppConstants.baseUrl}$endpoint'),
        headers: headers,
      );
      
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to perform DELETE request: $e');
    }
  }
  
  // Handle API response
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isNotEmpty) {
        return json.decode(response.body);
      }
      return null;
    } else {
      final errorMessage = response.body.isNotEmpty
          ? json.decode(response.body)['message'] ?? 'Unknown error'
          : 'Unknown error';
      throw Exception('API Error: $errorMessage (${response.statusCode})');
    }
  }
}