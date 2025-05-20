class AppConstants {
  // API endpoints
  static const String baseUrl = 'https://api.recyclebin.com';
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String itemsEndpoint = '/items';
  
  // Storage keys
  static const String tokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  
  // Recyclable categories
  static const List<Map<String, dynamic>> categories = [
    {'id': '1', 'name': 'Plastic', 'icon': 'assets/icons/plastic.png'},
    {'id': '2', 'name': 'Paper', 'icon': 'assets/icons/paper.png'},
    {'id': '3', 'name': 'Glass', 'icon': 'assets/icons/glass.png'},
    {'id': '4', 'name': 'Metal', 'icon': 'assets/icons/metal.png'},
    {'id': '5', 'name': 'Electronics', 'icon': 'assets/icons/electronics.png'},
    {'id': '6', 'name': 'Organic', 'icon': 'assets/icons/organic.png'},
  ];
  
  // Error messages
  static const String networkErrorMessage = 'Network error. Please check your connection.';
  static const String authErrorMessage = 'Authentication failed. Please try again.';
}