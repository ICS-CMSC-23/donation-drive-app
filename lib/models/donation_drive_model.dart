import 'dart:convert';

class DonationDrive {
  final String? id;
  final String organizationId;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> photos;

  DonationDrive({
    this.id,
    required this.organizationId,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    this.photos = const [],
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
      'organizationId': organizationId,
      'name': name,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'photos': photos,
    };
  }
}
