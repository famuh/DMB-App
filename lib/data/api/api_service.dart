import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/GuestSessionResponse.dart';

class ApiService {

static const API_KEY = "7328c41084b110c6a401b3cabef41b40";
static const BASE_URL ="https://api.themoviedb.org/3/";

// guest session
 Future<GuestSessionResponse> getGuestSession() async {
    final url = '${BASE_URL}authentication/guest_session/new';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $API_KEY',
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Check if the response is successful
        if (responseData['success'] == true) {
          return GuestSessionResponse.fromJson(responseData);
        } else {
          throw Exception('Failed to create guest session: ${responseData['status_message']}');
        }
      } else {
        throw Exception('Failed to get guest session. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error occurred while getting guest session: $error');
    }
 }

}