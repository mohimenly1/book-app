import 'package:flutter/material.dart';
import '../../services/reservation_service.dart';
import '../../model/reservation.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingScheduleScreen extends StatefulWidget {
  final int playgroundId;

  BookingScheduleScreen({required this.playgroundId});

  @override
  _BookingScheduleScreenState createState() => _BookingScheduleScreenState();
}

class _BookingScheduleScreenState extends State<BookingScheduleScreen> {
  late Future<Map<String, dynamic>> _schedule;
  late DateTime _selectedDate;
  late CalendarFormat _calendarFormat = CalendarFormat.week;
  late DateTime _focusedDay = DateTime.now();
  late DateTime _firstDay = DateTime.utc(
      DateTime.now().year, DateTime.now().month - 1, DateTime.now().day);
  late DateTime _lastDay = DateTime.utc(
      DateTime.now().year, DateTime.now().month + 1, DateTime.now().day);
  late String _openTime = '';
  late String _closeTime = '';
  String? _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _fetchSchedule();
  }

  void _fetchSchedule() {
    setState(() {
      _schedule = ReservationService.getSchedule(
          widget.playgroundId, _selectedDate.toIso8601String().split('T')[0]);
    });
  }

  Future<void> _bookTime() async {
    if (_selectedTime != null) {
      try {
        // Print the selected time for debugging
        print('Selected time: $_selectedTime');

        // Assuming the time format is "hh:mm AM/PM - hh:mm AM/PM"
        List<String> times = _selectedTime!.split(' - ');

        // Ensure that times have the correct length before processing
        if (times.length != 2) {
          throw FormatException("Invalid time format", _selectedTime);
        }

        // Print the split times for debugging
        print('Start time (raw): ${times[0]}');
        print('End time (raw): ${times[1]}');

        // Remove any non-printable characters from the times
        String cleanedStartTime =
            times[0].replaceAll(RegExp(r'[^\x20-\x7E]'), '').trim();
        String cleanedEndTime =
            times[1].replaceAll(RegExp(r'[^\x20-\x7E]'), '').trim();

        // Print the cleaned times for debugging
        print('Cleaned start time: $cleanedStartTime');
        print('Cleaned end time: $cleanedEndTime');

        // Ensure that the cleaned times are not empty and have valid lengths
        if (cleanedStartTime.isEmpty || cleanedEndTime.isEmpty) {
          throw FormatException(
              "Cleaned time strings are empty", _selectedTime);
        }

        DateTime startTime = DateFormat.jm().parse(cleanedStartTime);
        DateTime endTime = DateFormat.jm().parse(cleanedEndTime);

        // Print the parsed times for debugging
        print('Parsed startTime: $startTime');
        print('Parsed endTime: $endTime');

        // Set the selected date to the times
        startTime = DateTime(_selectedDate.year, _selectedDate.month,
            _selectedDate.day, startTime.hour, startTime.minute);
        endTime = DateTime(_selectedDate.year, _selectedDate.month,
            _selectedDate.day, endTime.hour, endTime.minute);

        // Format the times to the required format
        String formattedStartTime =
            DateFormat('yyyy-MM-dd HH:mm:ss').format(startTime);
        String formattedEndTime =
            DateFormat('yyyy-MM-dd HH:mm:ss').format(endTime);

        // Print the final start and end times for debugging
        print('Final startTime: $formattedStartTime');
        print('Final endTime: $formattedEndTime');

        // Replace with the actual calculation logic for total price
        double totalPrice = 50.0; // Example value

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userId = prefs.getString('user_id'); // Fetch the user ID
        if (userId == null) {
          throw Exception('User not authenticated');
        }

        // Print the request payload for debugging
        print({
          'user_id': userId,
          'playground_id': widget.playgroundId,
          'start_time': formattedStartTime,
          'end_time': formattedEndTime,
          'total_price': totalPrice,
          'status': 'pending',
        });

        bool success = await ReservationService.bookReservation(
            widget.playgroundId, startTime, endTime, totalPrice);

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Booking successful!')),
          );
          // Optionally, you can refresh the schedule after a successful booking
          _fetchSchedule();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Booking failed. Please try again.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
        // Log the error for debugging
        print('Error during booking: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'الحجوزات',
            style: TextStyle(
              fontFamily: 'TajawalRegular',
            ),
          ),
        ),
        body: Column(
          children: [
            FutureBuilder<Map<String, dynamic>>(
              future: _schedule,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  _openTime = snapshot.data!['open_time'];
                  _closeTime = snapshot.data!['close_time'];

                  final busyTimes = (snapshot.data!['busy_times'] as List)
                      .map((data) => Reservation.fromJson(data))
                      .toList();

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          '$_openTime : يفتح من الساعة',
                          style: TextStyle(
                            fontFamily: 'TajawalRegular',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '$_closeTime : يغلق من الساعة',
                          style: TextStyle(
                            fontFamily: 'TajawalRegular',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          ': الأوقات المحجوزة',
                          style: TextStyle(
                            fontFamily: 'TajawalRegular',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Column(
                          children: busyTimes.map((reservation) {
                            return Text(
                              '${DateFormat.jm().format(reservation.startTime)} - ${DateFormat.jm().format(reservation.endTime)}',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            TableCalendar(
              firstDay: _firstDay,
              lastDay: _lastDay,
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              availableGestures: AvailableGestures.horizontalSwipe,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarStyle: CalendarStyle(
                todayTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDate = selectedDay;
                  _focusedDay = focusedDay;
                  _fetchSchedule();
                });
              },
            ),
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: _schedule,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    final busyTimes = (snapshot.data!['busy_times'] as List)
                        .map((data) => Reservation.fromJson(data))
                        .toList();
                    final availableTimes =
                        (snapshot.data!['available_times'] as List)
                            .map((time) =>
                                "${time['start_time']} - ${time['end_time']}")
                            .toList();

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 2,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 4.0,
                      ),
                      itemCount: availableTimes.length,
                      itemBuilder: (context, index) {
                        final time = availableTimes[index];
                        final isBusy = busyTimes.any((reservation) =>
                            "${DateFormat.jm().format(reservation.startTime)} - ${DateFormat.jm().format(reservation.endTime)}" ==
                            time);
                        final isSelected = _selectedTime == time;

                        return GestureDetector(
                          onTap: isBusy
                              ? null
                              : () {
                                  setState(() {
                                    _selectedTime = time;
                                  });

                                  // Handle reservation for this time
                                  String selectedTime = time;
                                  print('Selected time: $selectedTime');
                                },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors
                                      .blue // Change color for selected time
                                  : (isBusy ? Colors.red : Colors.green),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Center(
                              child: Text(
                                time,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            ElevatedButton(
              onPressed: _selectedTime != null ? _bookTime : null,
              child: Text('Book'),
            ),
          ],
        ));
  }
}
