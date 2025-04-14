import 'package:shop_mate/data/models/businesses/features_model.dart';
import 'package:shop_mate/core/utils/constants_enums.dart';

class Subscription {
  final String tier; // e.g., "Free", "Basic", "Standard", "Premium"
  final int inventoryLimit;
  final int salesLimit;
  final List<Feature>
      accessibleFeatures; // e.g., ["Inventory Alerts", "Chat System"]
  final DateTime? subscriptionStartDate;
  final DateTime? subscriptionEndDate;
  final Map<String, dynamic>? addOns; // Optional features user has purchased

  Subscription({
    required this.tier,
    required this.inventoryLimit,
    required this.salesLimit,
    required this.accessibleFeatures,
    this.subscriptionStartDate,
    this.subscriptionEndDate,
    this.addOns,
  });

  factory Subscription.defaultSubscription() {
    return Subscription(
      tier: SubscriptionTiers.basic.name,
      accessibleFeatures: [
        Feature(name: "inventory_management"),
        Feature(name: "sales_tracking"),
      ],
      inventoryLimit: 100,
      salesLimit: 500,
    );
  }

  // JSON Deserialization
  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      tier: json['tier'] as String,
      inventoryLimit: json['inventoryLimit'] as int,
      salesLimit: json['salesLimit'] as int,
      accessibleFeatures: (json['accessibleFeatures'] as List<dynamic>)
          .map((featureJson) => Feature.fromJson(featureJson))
          .toList(),
      subscriptionStartDate: json['subscriptionStartDate'] != null
          ? DateTime.parse(json['subscriptionStartDate'])
          : null,
      subscriptionEndDate: json['subscriptionEndDate'] != null
          ? DateTime.parse(json['subscriptionEndDate'])
          : null,
      addOns: json['addOns'] as Map<String, dynamic>?,
    );
  }

  // JSON Serialization
  Map<String, dynamic> toJson() {
    return {
      'tier': tier,
      'inventoryLimit': inventoryLimit,
      'salesLimit': salesLimit,
      'accessibleFeatures': accessibleFeatures.map((feature) => feature.toJson()).toList(),
      'subscriptionStartDate': subscriptionStartDate?.toIso8601String(),
      'subscriptionEndDate': subscriptionEndDate?.toIso8601String(),
      'addOns': addOns,
    };
  }

  // CSV Serialization
  String toCSV() {
    String featuresCSV = accessibleFeatures.map((feature) => feature.name).join(';');
    return '$tier, $inventoryLimit, $salesLimit, $featuresCSV, ${subscriptionStartDate?.toIso8601String()}, ${subscriptionEndDate?.toIso8601String()}, ${addOns.toString()}';
  }

  // CSV Deserialization
  factory Subscription.fromCSV(String csv) {
    final parts = csv.split(',').map((part) => part.trim()).toList();
    if (parts.length < 7) {
      throw Exception('Invalid CSV format for Subscription');
    }

    return Subscription(
      tier: parts[0],
      inventoryLimit: int.parse(parts[1]),
      salesLimit: int.parse(parts[2]),
      accessibleFeatures: parts[3].split(';').map((featureName) => Feature(name: featureName)).toList(),
      subscriptionStartDate: parts[4].isNotEmpty ? DateTime.parse(parts[4]) : null,
      subscriptionEndDate: parts[5].isNotEmpty ? DateTime.parse(parts[5]) : null,
      addOns: parts[6].isNotEmpty ? Map<String, dynamic>.from(parts[6] as Map) : null,
    );
  }
}
