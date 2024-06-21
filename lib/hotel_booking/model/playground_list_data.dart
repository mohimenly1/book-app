// File: lib/models/playground.dart

import 'dart:convert';

class Playground {
  final int id;
  final int ownerId;
  final String name;
  final String description;
  final double pricePerHalfHour;
  final double pricePerHour;
  final List<String> images;

  Playground({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.description,
    required this.pricePerHalfHour,
    required this.pricePerHour,
    required this.images,
  });

  factory Playground.fromJson(Map<String, dynamic> json) {
    return Playground(
      id: json['id'],
      ownerId: json['owner_id'],
      name: json['name'],
      description: json['description'],
      pricePerHalfHour: double.parse(json['price_per_half_hour'].toString()),
      pricePerHour: double.parse(json['price_per_hour'].toString()),
      images: (json['images'] as List<dynamic>).cast<String>(),
    );
  }
}
