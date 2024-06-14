// File: lib/services/playground_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../hotel_booking/model/playground_list_data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PlaygroundService {
  static Future<List<Playground>> fetchPlaygrounds() async {
    final String apiUrl = dotenv.env['API_URL']!;
    final response = await http.get(Uri.parse('$apiUrl/playground'));
    print(response.body);
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Playground.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load playgrounds');
    }
  }
}
