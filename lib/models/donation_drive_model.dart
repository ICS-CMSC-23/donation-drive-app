import 'dart:convert';

class DonationDrive {
  final String? id;
  final String organizationId;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> photos; // Proof photos
  final List<String> donationIds; // Linked donations

  DonationDrive({
    this.id,
    required this.organizationId,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    this.photos = const [],
    this.donationIds = const [],
  });

  factory DonationDrive.fromJson(Map<String, dynamic> json) {
    return DonationDrive(
      id: json['id'],
      organizationId: json['organizationId'],
      name: json['name'],
      description: json['description'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      photos: List<String>.from(json['photos']),
      donationIds: List<String>.from(json['donationIds']),
    );
  }

  static List<DonationDrive> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data
        .map<DonationDrive>((dynamic d) => DonationDrive.fromJson(d))
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organizationId': organizationId,
      'name': name,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'photos': photos,
      'donationIds': donationIds,
    };
  }
}
