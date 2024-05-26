import 'dart:convert';

class Donor {
  final int? userId;
  String? id;
  final String name;
  final String username;
  final String password;
  final List<String> addresses;
  final String contactNo;

  Donor({
    this.userId,
    this.id,
    required this.name,
    required this.username,
    required this.password,
    required this.addresses,
    required this.contactNo,
  });

  factory Donor.fromJson(Map<String, dynamic> json) {
    return Donor(
      userId: json['userId'],
      id: json['id'],
      name: json['name'],
      username: json['username'],
      password: json['password'],
      addresses: List<String>.from(json['addresses']),
      contactNo: json['contactNo'],
    );
  }

  static List<Donor> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Donor>((dynamic d) => Donor.fromJson(d)).toList();
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
    };
  }
}
