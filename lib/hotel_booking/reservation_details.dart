import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/hotel_booking/model/playground_list_data.dart' as model;

class Reservation {
  final int id;
  final int userId;
  final int playgroundId;
  final DateTime startTime;
  final DateTime endTime;
  final double totalPrice;
  final String status;
  final model.Playground playground;

  Reservation({
    required this.id,
    required this.userId,
    required this.playgroundId,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    required this.status,
    required this.playground,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      playgroundId: json['playground_id'] ?? 0,
      startTime: DateTime.tryParse(json['start_time'] ?? '') ?? DateTime.now(),
      endTime: DateTime.tryParse(json['end_time'] ?? '') ?? DateTime.now(),
      totalPrice:
          double.tryParse(json['total_price']?.toString() ?? '0.0') ?? 0.0,
      status: json['status'] ?? '',
      playground: model.Playground.fromJson(json['playground'] ?? {}),
    );
  }
}

class ReservationDetailsScreen extends StatefulWidget {
  const ReservationDetailsScreen({super.key});
  @override
  _ReservationDetailsScreenState createState() =>
      _ReservationDetailsScreenState();
}

class _ReservationDetailsScreenState extends State<ReservationDetailsScreen> {
  late List<Reservation> reservations = [];

  @override
  void initState() {
    super.initState();
    fetchReservations();
  }

  Future<void> fetchReservations() async {
    final String apiUrl = dotenv.env['API_URL']!;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    final response =
        await http.get(Uri.parse('$apiUrl/user-reservations'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);

      // Debug: Print response data to console
      print('Response data: $responseData');

      setState(() {
        reservations =
            responseData.map((data) => Reservation.fromJson(data)).toList();
      });
    } else {
      throw Exception('Failed to load reservations');
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.green;
      case 'canceled':
        return Colors.red;
      case 'pending':
      default:
        return Colors.yellow;
    }
  }

  String translateStatus(String status) {
    switch (status) {
      case 'confirmed':
        return 'تم الحجز';
      case 'canceled':
        return 'الحجز ملغي';
      case 'pending':
      default:
        return 'قيد الإنتظار';
    }
  }

  Widget _buildPlaygroundImage(String base64Image) {
    if (base64Image.isNotEmpty && base64Image.startsWith('data:image')) {
      // Decode base64 image
      final bytes = base64.decode(base64Image.split(',').last);
      return Image.memory(
        bytes,
        fit: BoxFit.cover,
        width: 60,
        height: 60,
      );
    } else {
      // Placeholder or default image
      return Image.asset(
        'assets/images/placeholder.jpg',
        fit: BoxFit.cover,
        width: 60,
        height: 60,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'حجوزاتي',
          style: TextStyle(fontFamily: 'HacenSamra'),
        ),
      ),
      body: reservations.isNotEmpty
          ? ListView.builder(
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: _buildPlaygroundImage(
                        reservations[index].playground.images.isNotEmpty
                            ? reservations[index].playground.images[0]
                            : ''),
                    title: Text(
                      reservations[index].playground.name,
                      style: TextStyle(fontFamily: 'HacenSamra'),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            '${reservations[index].startTime} - ${reservations[index].endTime}'),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: getStatusColor(reservations[index].status),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Text(
                            translateStatus(reservations[index].status),
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'HacenSamra'),
                          ),
                        ),
                      ],
                    ),
                    trailing: Text(
                      '\ دينار ${reservations[index].totalPrice.toStringAsFixed(2)}',
                    ),
                  ),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
