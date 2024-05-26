import 'dart:convert';

class Donation {
  final int? organizationId; // Identifies which organization made the donation
  String? id;
  final List<String> categories;
  final bool isPickup; // True for pick-up, False for drop-off
  final double weight;
  final String? photoUrl; // Optional, linked to a photo in the Firebase Storage
  final DateTime dateTime;
  final List<String> addresses; // Can save multiple addresses
  final String contactNo;

  Donation({
    required this.organizationId,
    this.id,
    required this.categories,
    required this.isPickup,
    required this.weight,
    this.photoUrl,
    required this.dateTime,
    required this.addresses,
    required this.contactNo,
  });

  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      organizationId: json['organizationId'],
      id: json['id'],
      categories: List<String>.from(json['categories']),
      isPickup: json['isPickup'],
      weight: json['weight'],
      photoUrl: json['photoUrl'],
      dateTime: DateTime.parse(json['dateTime']),
      addresses: List<String>.from(json['addresses']),
      contactNo: json['contactNo'],
    );
  }

  static List<Donation> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Donation>((dynamic d) => Donation.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'organizationId': organizationId,
      'id': id,
      'categories': categories,
      'isPickup': isPickup,
      'weight': weight,
      'photoUrl': photoUrl,
      'dateTime': dateTime.toIso8601String(),
      'addresses': addresses,
      'contactNo': contactNo,
    };
  }
}
