import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeScreen extends StatelessWidget {
  final Map<String, dynamic> reservation;

  QRCodeScreen({required this.reservation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reservation QR Code',
          style: TextStyle(fontFamily: 'TajawalRegular'),
        ),
      ),
      body: Center(
        child: QrImageView(
          data: json.encode(reservation),
          version: QrVersions.auto,
          size: 200.0,
        ),
      ),
    );
  }
}
