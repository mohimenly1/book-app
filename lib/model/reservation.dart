class Reservation {
  final DateTime startTime;
  final DateTime endTime;

  Reservation({required this.startTime, required this.endTime});

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
    );
  }
}
