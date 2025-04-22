import 'package:velocity_x/velocity_x.dart';

class User {
  int id;
  int? vendorId;
  String name;
  String email;
  String phone;
  String? rawPhone;
  String? countryCode;
  String photo;
  String role;
  bool isOnline;
  bool hasMultipleVendors;
  String? createdAt;

  User({
    required this.id,
    required this.vendorId,
    required this.name,
    required this.email,
    required this.phone,
    required this.photo,
    required this.role,
    required this.isOnline,
    this.rawPhone,
    this.countryCode,
    this.createdAt,
    //for vendor profile switcher
    this.hasMultipleVendors = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      vendorId: json['vendor_id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      rawPhone: json['raw_phone'],
      countryCode: json['country_code'],
      photo: json['photo'] ?? "",
      createdAt: json['created_at'] ?? '',
      role: json['role_name'] ?? "client",
      isOnline: json['is_online'] == null ? false : json['is_online'] == 1,
      hasMultipleVendors: json['has_multiple_vendors'] != null
          ? (json['has_multiple_vendors'] ?? false)
          : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendor_id': vendorId,
      'name': name,
      'email': email,
      'phone': phone,
      'raw_phone': rawPhone,
      'country_code': countryCode,
      'photo': photo,
      'role_name': role,
      'is_online': isOnline,
      'created_at': createdAt,
      'has_multiple_vendors': hasMultipleVendors,
    };
  }

  String getCapitalizedName() {
    if (name.split(' ').length > 1) {
      return "${name.split(' ').first} ${name.split(' ')[1].firstLetterUpperCase()[0]}";
    }
    return name;
  }
}
