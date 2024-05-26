import 'dart:convert';

class Organization {
  final int? userId;
  String? id;
  final String name;
  final String username;
  final String password;
  final List<String> addresses;
  final String contactNo;
  final String orgName;
  final List<String> proofsOfLegitimacy;
  final bool isApproved;

  Organization({
    this.userId,
    this.id,
    required this.name,
    required this.username,
    required this.password,
    required this.addresses,
    required this.contactNo,
    required this.orgName,
    required this.proofsOfLegitimacy,
    this.isApproved = false,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      userId: json['userId'],
      id: json['id'],
      name: json['name'],
      username: json['username'],
      password: json['password'],
      addresses: List<String>.from(json['addresses']),
      contactNo: json['contactNo'],
      orgName: json['orgName'],
      proofsOfLegitimacy: List<String>.from(json['proofsOfLegitimacy']),
      isApproved: json['isApproved'],
    );
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
      'id': id,
      'name': name,
      'username': username,
      'password': password,
      'addresses': addresses,
      'contactNo': contactNo,
      'orgName': orgName,
      'proofsOfLegitimacy': proofsOfLegitimacy,
      'isApproved': isApproved,
    };
  }
}
