import 'package:freezed_annotation/freezed_annotation.dart';

import 'base_model.dart';

part 'transaction.g.dart';

@JsonSerializable(explicitToJson: true)
class Transaction extends BaseModel {
  String? type;
  String? productID;
  String? businessID;
  TransactionType transactionType;
  String? quantity;
  String? notes;

  Transaction({
    required super.id,
    required super.name,
    required this.businessID,
    required this.productID,
    this.type,
    required this.transactionType,
    this.quantity,
    this.notes,
    super.createdAt,
    super.updatedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}

enum TransactionType { sale, transfer, supply }
