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
  final int
      status; // 0 Pending, 1 Confirmed, 2 Scheduled for pick-up, 3 Complete, 4 Canceled
  final int donorId;
  final String? donationDriveId;

  Donation(
      {required this.organizationId,
      this.id,
      required this.categories,
      required this.isPickup,
      required this.weight,
      this.photoUrl,
      required this.dateTime,
      required this.addresses,
      required this.contactNo,
      required this.status,
      required this.donorId,
      this.donationDriveId});

  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
        organizationId: json['organizationId'],
        id: json['id'],
        categories: List<String>.from(json['categories']),
        isPickup: json['isPickup'],
        weight: (json['weight'] as num).toDouble(),
        photoUrl: json['photoUrl'],
        dateTime: DateTime.parse(json['dateTime']),
        addresses: List<String>.from(json['addresses']),
        contactNo: json['contactNo'],
        status: json['status'],
        donorId: json['donorId'],
        donationDriveId: json['donationDriveId']);
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
      'status': status,
      'donorId': donorId,
      'donationDriveId': donationDriveId
    };
  }
}
