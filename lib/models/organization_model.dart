import 'dart:convert';

class Organization {
  final int? userId;
  String? id;
  final String name;
  final String username;
  final String password;
  final List<String> addresses;
  final String contactNo;
  final String organizationName;
  final List<String> proofsOfLegitimacy;
  final bool isApproved; // True for approved, False for disapproved
  final String? about;
  final bool isOpen; // True for open, False for close
  final List<String> donationDriveIds;

  Organization(
      {this.userId,
      this.id,
      required this.name,
      required this.username,
      required this.password,
      required this.addresses,
      required this.contactNo,
      required this.organizationName,
      required this.proofsOfLegitimacy,
      this.isApproved = false,
      this.about,
      this.isOpen = true,
      this.donationDriveIds = const []});

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
        userId: json['userId'],
        id: json['id'],
        name: json['name'],
        username: json['username'],
        password: json['password'],
        addresses: List<String>.from(json['addresses']),
        contactNo: json['contactNo'],
        organizationName: json['organizationName'],
        proofsOfLegitimacy: List<String>.from(json['proofsOfLegitimacy']),
        isApproved: json['isApproved'],
        about: json['about'],
        isOpen: json['isOpen'],
        donationDriveIds: List<String>.from(json['donationDriveIds']));
  }

  static List<Organization> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data
        .map<Organization>((dynamic d) => Organization.fromJson(d))
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'username': username,
      'password': password,
      'addresses': addresses,
      'contactNo': contactNo,
      'organizationName': organizationName,
      'proofsOfLegitimacy': proofsOfLegitimacy,
      'isApproved': isApproved,
      'about': about,
      'isOpen': isOpen,
      'donationDriveIds': donationDriveIds
    };
  }
}
