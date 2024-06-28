import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:qr_flutter/qr_flutter.dart';
import 'qr_code_screen.dart'; // Add this line

class BookingScheduleScreen extends StatefulWidget {
  final int playgroundId;

  BookingScheduleScreen({required this.playgroundId});

  @override
  _BookingScheduleScreenState createState() => _BookingScheduleScreenState();
}

class _BookingScheduleScreenState extends State<BookingScheduleScreen> {
  late DateTime _selectedDate;
  late Future<List<Map<String, String>>> _availableTimes;
  String? _selectedStartTime;
  String? _selectedEndTime;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _availableTimes = _fetchAvailableTimes(_selectedDate);
  }

  Future<List<Map<String, String>>> _fetchAvailableTimes(DateTime date) async {
    final String apiUrl = dotenv.env['API_URL']!;
    final response = await http.get(
      Uri.parse(
          '$apiUrl/playgrounds/${widget.playgroundId}/schedule/${DateFormat('yyyy-MM-dd').format(date)}'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> availableTimes = data['available_times'];
      List<Map<String, String>> converted = [];

      for (var slot in availableTimes) {
        converted.add({
          'start_time': slot['start_time'],
          'end_time': slot['end_time'],
        });
      }

      return converted;
    } else {
      throw Exception('Failed to load schedule');
    }
  }

  Future<void> _postBooking(String startTime, String endTime) async {
    final String apiUrl = dotenv.env['API_URL']!;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getInt('user_id').toString();
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
        'playground_id': widget.playgroundId,
        'start_time': startTime,
        'end_time': endTime,
        'status': 'pending',
      }),
    );

    if (response.statusCode == 201) {
      var reservation = json.decode(response.body);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QRCodeScreen(reservation: reservation),
        ),
      );
    } else {
      throw Exception('Failed to book reservation');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Booking Schedule',
          style: TextStyle(
            fontFamily: 'TajawalRegular',
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Map<String, String>>>(
          future: _availableTimes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No available times'));
            } else {
              List<Map<String, String>> availableTimes = snapshot.data!;
              String openTime = availableTimes.first['start_time']!;
              String closeTime = availableTimes.last['end_time']!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Open Time: $openTime',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Close Time: $closeTime',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Available Times:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: availableTimes
                                .sublist(0, (availableTimes.length / 2).ceil())
                                .map((slot) => _buildTimeSlot(slot))
                                .toList(),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: availableTimes
                                .sublist((availableTimes.length / 2).ceil())
                                .map((slot) => _buildTimeSlot(slot))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: _selectedStartTime != null
                          ? () async {
                              String startTime =
                                  '${DateFormat('yyyy-MM-dd').format(_selectedDate)} $_selectedStartTime';
                              String endTime =
                                  '${DateFormat('yyyy-MM-dd').format(_selectedDate)} $_selectedEndTime';
                              if (_selectedEndTime == '12:00 AM' ||
                                  _selectedEndTime == '01:00 AM' ||
                                  _selectedEndTime == '02:00 AM') {
                                endTime =
                                    '${DateFormat('yyyy-MM-dd').format(_selectedDate.add(Duration(days: 1)))} $_selectedEndTime';
                              }
                              try {
                                await _postBooking(startTime, endTime);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Failed to book reservation: $e')),
                                );
                              }
                            }
                          : null,
                      child: Text('Book'),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildTimeSlot(Map<String, String> slot) {
    bool isSelected = _selectedStartTime == slot['start_time'];
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStartTime = slot['start_time'];
          _selectedEndTime = slot['end_time'];
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.green,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '${slot['start_time']} - ${slot['end_time']}',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
