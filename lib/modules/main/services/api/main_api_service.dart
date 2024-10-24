import 'package:flutter_core/services/api/base_api_service.dart';

class MainModuleApiService {
  final BaseApiService mainApiService;

  MainModuleApiService(this.mainApiService);

  // Get Categories by calling BaseApiService with GET method
  Future<List<String>> getCategories() async {
    String route = '/get-categories';

    // Send a GET request using the mainApiService
    dynamic response = await mainApiService.sendRequest(
      route,
      method: 'GET', // Specify GET method
    );

    if (response != null && response is List<dynamic>) {
      // Cast the dynamic list to a list of strings
      return response.cast<String>();
    } else {
      throw Exception('Failed to load categories');
    }
  }

// Get a single celeb's details by calling BaseApiService with the category as a parameter
  Future<Map<String, dynamic>> getCelebDetails(String selectedCategory) async {
    // Define the API route, appending the category as a query parameter
    String route = '/get-celeb-details?category=$selectedCategory';

    // Send a GET request using the mainApiService
    dynamic response = await mainApiService.sendRequest(
      route,
      method: 'GET', // Specify GET method
    );

    // Print the raw response for debugging
    print('API Response: $response');

    if (response != null && response is Map<String, dynamic>) {
      // Check for null values and provide default empty lists if necessary
      return {
        'name': response['name'] ?? 'Unknown',
        // Fallback in case name is null
        'facts': List<String>.from(response['facts'] ?? []),
        // Handle null with an empty list
        'image': (response['image'] is String) ? response['image'] : '',
        // Add image URL from the API response or fallback to an empty string
      };
    } else {
      throw Exception('Failed to load celebrity details');
    }
  }
}
