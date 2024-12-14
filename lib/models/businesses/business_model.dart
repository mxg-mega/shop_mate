import 'package:shop_mate/models/base_model.dart';
import 'package:shop_mate/models/users/constants_enums.dart';

class Business extends BaseModel {
  final String? email;
  final String address;
  final String phone;
  final BusinessCategories businessType;
  final String? token;

  Business({
    required super.id,
    required super.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.businessType,
    this.token,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String,
      address: json['address'] as String,
      businessType: BusinessCategories.values.firstWhere(
          (b) => b.name == json['businessType'] as String,
          orElse: () => BusinessCategories.other),
      token: json['token'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return super.toJson()
      ..addAll({
        'email': email,
        'phone': phone,
        'address': address,
        'businessType': businessType.name,
        'token': token,
      });
  }

  @override
  String toCSV() {
    return '${super.toCSV()} , $email , $phone , $address , ${businessType.name}';
  }

  factory Business.fromCSV(String csv) {
    final parts = csv.split(',').map((part) => part.trim()).toList();
    BaseModel.validateCSVParts(parts, 6);

    return Business(
      id: parts[0],
      name: parts[1],
      email: parts[2],
      phone: parts[3],
      address: parts[4],
      businessType: BusinessCategories.values.firstWhere(
          (btype) => btype.name == parts[5],
          orElse: () => BusinessCategories.other),
    );
  }
}
