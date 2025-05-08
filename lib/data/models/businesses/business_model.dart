import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shop_mate/data/models/base_model.dart';
import 'package:shop_mate/data/models/businesses/business_settings.dart';
import 'package:shop_mate/data/models/businesses/subscription_model.dart';
import 'package:shop_mate/core/utils/constants_enums.dart';
part 'business_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Business extends BaseModel {
  final String? email;
  final String address;
  final String? phone;
  final String ownerId;
  final BusinessCategories businessType;
  final String? token;
  Subscription subscription;
  String? businessAbbrev;
  List<String>? locations;
  BusinessSettings? businessSettings;

  Business({
    required super.id,
    required super.name,
    this.email,
    this.phone,
    required this.address,
    required this.businessType,
    required this.ownerId,
    this.token,
    Subscription? subscription,
    this.businessAbbrev,
    this.locations,
    BusinessSettings? businessSettings,
  })  : subscription = subscription ?? Subscription.defaultSubscription(),
        businessSettings =
            businessSettings ?? BusinessSettings.defaultSettings(ownerId) {
              locations ??= ["Store", "Warehouse"];
            }

  factory Business.fromJson(Map<String, dynamic> json) =>
      _$BusinessFromJson(json);
  // {
  //   return Business(
  //     id: json['id'] as String,
  //     name: json['name'] as String,
  //     email: json['email'] as String?,
  //     phone: json['phone'] as String?,
  //     address: json['address'] as String,
  //     ownerId: json['ownerId'] as String,
  //     businessType: BusinessCategories.values.firstWhere(
  //         (b) => b.name == json['businessType'] as String,
  //         orElse: () => BusinessCategories.other),
  //     token: json['token'] as String?,
  //     employees: (json['employees'] as List<dynamic>)
  //         .map((data) => Employee.fromJson(data))
  //         .toList(),
  //     subscription: json['subscription'] != null
  //         ? Subscription.fromJson(json['subscription'] as Map<String, dynamic>)
  //         : Subscription.defaultSubscription(),
  //     businessAbbrev: json['businessAbbrev'] as String?,
  //     businessSettings: json['businessSettings'] != null
  //         ? BusinessSettings.fromJson(json['businessSettings'] as Map<String, dynamic>)
  //         : BusinessSettings.defaultSettings(json['ownerId'] as String),
  //   );
  // }

  @override
  Map<String, dynamic> toJson() => _$BusinessToJson(this);
  // @override
  // Map<String, dynamic> toJson() {
  //   return super.toJson()
  //     ..addAll({
  //       'email': email,
  //       'phone': phone,
  //       'address': address,
  //       'businessType': businessType.name,
  //       'token': token,
  //       'employees': employees.map((employee) => employee.toJson()).toList(),
  //       'subscription': subscription.toJson(),
  //       'ownerId': ownerId,
  //       'businessAbbrev': businessAbbrev,
  //       'businessSettings': businessSettings?.toJson(),
  //     });
  // }

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
    Subscription? subscription,
    String? bizIdentifier,
    List<String>? locations,
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
      subscription: subscription ?? this.subscription,
      businessAbbrev: bizIdentifier ?? this.businessAbbrev,
      businessSettings: businessSettings ?? this.businessSettings,
      locations: locations!.isNotEmpty ? locations : this.locations,
    );
  }

  // @override
  // String toCSV() {
  //   String subscriptionCSV = subscription.toCSV();
  //   return '${super.toCSV()} , $email , $phone , $address , ${businessType.name}, $subscriptionCSV';
  // }

  // factory Business.fromCSV(String csv) {
  //   final parts = csv.split(',').map((part) => part.trim()).toList();
  //   BaseModel.validateCSVParts(parts, 8);
  //   Subscription subscription = Subscription.fromCSV(parts[6]);
  //   return Business(
  //     id: parts[0],
  //     name: parts[1],
  //     email: parts[2],
  //     phone: parts[3],
  //     address: parts[4],
  //     businessType: BusinessCategories.values.firstWhere(
  //         (btype) => btype.name == parts[5],
  //         orElse: () => BusinessCategories.other),
  //     subscription: subscription,
  //     ownerId: parts[7],
  //   );
  // }
}
