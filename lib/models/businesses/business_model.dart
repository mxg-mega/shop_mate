import 'package:shop_mate/models/base_model.dart';
import 'package:shop_mate/models/businesses/business_settings.dart';
import 'package:shop_mate/models/businesses/subscription_model.dart';
import 'package:shop_mate/core/utils/constants_enums.dart';
import 'package:shop_mate/models/users/employee_model.dart';

class Business extends BaseModel {
  final String? email;
  final String address;
  final String phone;
  final String ownerId;
  final BusinessCategories businessType;
  final String? token;
  List<Employee> employees;
  Subscription subscription;
  String? bizIdentifier;
  BusinessSettings? businessSettings;

  Business({
    required super.id,
    required super.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.businessType,
    required this.ownerId,
    this.token,
    this.employees = const [],
    Subscription? subscription,
    this.bizIdentifier,
    BusinessSettings?  businessSettings,

  })  : subscription = subscription ?? Subscription.defaultSubscription(),
        businessSettings = businessSettings ?? BusinessSettings.defaultSettings(ownerId);

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
          .map((data) => Employee.fromJson(data))
          .toList(),
      subscription: json['subscription'] != null
          ? Subscription.fromJson(json['subscription'] as Map<String, dynamic>)
          : Subscription.defaultSubscription(),
      bizIdentifier: json['bizIdentifier'] as String?,
      businessSettings: json['businessSettings'] != null
          ? BusinessSettings.fromJson(json['businessSettings'] as Map<String, dynamic>)
          : BusinessSettings.defaultSettings(json['ownerId'] as String),
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
        'ownerId': ownerId,
        'bizIdentifier': bizIdentifier,
        'businessSettings': businessSettings?.toJson(),
      });
  }

  /// Creates a new instance with updated fields while retaining unchanged ones.
  @override
  Business copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    BusinessCategories? businessType,
    String? ownerId,
    String? token,
    List<Employee>? employees,
    Subscription? subscription,
    String? bizIdentifier,
    BusinessSettings? businessSettings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Business(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      businessType: businessType ?? this.businessType,
      ownerId: ownerId ?? this.ownerId,
      token: token ?? this.token,
      employees: employees ?? this.employees,
      subscription: subscription ?? this.subscription,
      bizIdentifier: bizIdentifier ?? this.bizIdentifier,
      businessSettings: businessSettings ?? this.businessSettings,
    );
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
