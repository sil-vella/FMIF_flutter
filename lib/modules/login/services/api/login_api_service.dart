import 'package:flutter_core/services/api/base_api_service.dart';

class LoginApiService {
  final BaseApiService mainApiService;

  LoginApiService(this.mainApiService);

  // Login method using POST request
  Future<dynamic> login(String username, String password) async {
    String route = '/login';
    Map<String, dynamic> data = {
      'username': username,
      'password': password,
    };

    // Ensure the method is explicitly specified as POST
    return await mainApiService.sendRequest(
      route,
      method: 'POST', // Specify POST method
      data: data, // Pass the data for POST request
    );
  }

  // Register method using POST request
  Future<dynamic> register(String username, String password) async {
    String route = '/register';
    Map<String, dynamic> data = {
      'username': username,
      'password': password,
    };

    // Ensure the method is explicitly specified as POST
    return await mainApiService.sendRequest(
      route,
      method: 'POST', // Specify POST method
      data: data, // Pass the data for POST request
    );
  }
}
