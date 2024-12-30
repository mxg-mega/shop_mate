import 'package:shop_mate/models/base_model.dart';
import 'package:shop_mate/models/businesses/subscription_model.dart';
import 'package:shop_mate/models/users/constants_enums.dart';
import 'package:shop_mate/models/users/employee_model.dart';

class Business extends BaseModel {
  final String? email;
  final String address;
  final String phone;
  final String? ownerId;
  final BusinessCategories businessType;
  final String? token;
  List<Employee> employees;
  Subscription subscription;

  Business({
    required super.id,
    required super.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.businessType,
    this.ownerId,
    this.token,
    this.employees = const [],
    Subscription? subscription,
  }) : subscription = subscription ?? Subscription.defaultSubscription();

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String,
      address: json['address'] as String,
      ownerId: json['ownerId'] as String,
      businessType: BusinessCategories.values.firstWhere(
          (b) => b.name == json['businessType'] as String,
          orElse: () => BusinessCategories.other),
      token: json['token'] as String?,
      employees: (json['employees'] as List<dynamic>)
          .map((employeejson) => Employee.fromJson(employeejson))
          .toList(),
      subscription: json['subscription'] != null
          ? Subscription.fromJson(json['subscription'] as Map<String, dynamic>)
          : Subscription.defaultSubscription(),
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
        'employees': employees.map((employee) => employee.toJson()).toList(),
        'subscription': subscription.toJson(),
      });
  }

  @override
  String toCSV() {
    String subscriptionCSV = subscription.toCSV();
    return '${super.toCSV()} , $email , $phone , $address , ${businessType.name}, $subscriptionCSV';
  }

  factory Business.fromCSV(String csv) {
    final parts = csv.split(',').map((part) => part.trim()).toList();
    BaseModel.validateCSVParts(parts, 8);
    Subscription subscription = Subscription.fromCSV(parts[6]);
    return Business(
      id: parts[0],
      name: parts[1],
      email: parts[2],
      phone: parts[3],
      address: parts[4],
      businessType: BusinessCategories.values.firstWhere(
          (btype) => btype.name == parts[5],
          orElse: () => BusinessCategories.other),
      subscription: subscription,
      ownerId: parts[7],
    );
  }
}
