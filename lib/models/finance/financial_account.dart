import 'package:shop_mate/models/base_model.dart';

class FinancialAccount extends BaseModel {
  final String type; // cash, bank, credit
  final double balance;
  final String currency;
  final bool isActive;

  FinancialAccount({
    required super.id,
    required super.name,
    required this.type,
    required this.balance,
    required this.currency,
    required this.isActive,
    required super.createdAt,
    required super.updatedAt,
  });

  factory FinancialAccount.fromJson(Map<String, dynamic> json) =>
      FinancialAccount(
        id: json['id'],
        name: json['name'],
        type: json['type'],
        balance: json['balance'].toDouble(),
        currency: json['currency'],
        isActive: json['isActive'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  @override
  Map<String, dynamic> toJson() => super.toJson()
    ..addAll({
      'name': name,
      'type': type,
      'balance': balance,
      'currency': currency,
      'isActive': isActive,
    });
}