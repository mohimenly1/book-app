// File: lib/services/reservation_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReservationService {
  static Future<Map<String, dynamic>> getSchedule(
      int playgroundId, String date) async {
    final String apiUrl = dotenv.env['API_URL']!;
    final response = await http
        .get(Uri.parse('$apiUrl/playgrounds/$playgroundId/schedule/$date'));

    print('API Response: ${response.body}'); // Print the response

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load schedule');
    }
  }

  static Future<bool> bookReservation(int playgroundId, DateTime startTime,
      DateTime endTime, double totalPrice) async {
    final String apiUrl = dotenv.env['API_URL']!;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    String? token = prefs.getString('access_token');

    if (userId == null || token == null) {
      throw Exception('User not authenticated');
    }

    final response = await http.post(
      Uri.parse('$apiUrl/reservations'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'user_id': userId,
        'playground_id': playgroundId,
        'start_time': startTime.toIso8601String(),
        'end_time': endTime.toIso8601String(),
        'total_price': totalPrice,
        'status': 'pending',
      }),
    );

    print('Booking Response: ${response.body}');

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
