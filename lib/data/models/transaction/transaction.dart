import 'package:freezed_annotation/freezed_annotation.dart';

import '../base_model.dart';

part 'transaction.g.dart';

@JsonSerializable(explicitToJson: true)
class Transactions extends BaseModel {
  String? type;
  String? productId;
  String? businessId;
  TransactionsType transactionsType;
  String? quantity;
  String? notes;

  Transactions({
    required super.id,
    required super.name,
    required this.businessId,
    required this.productId,
    this.type,
    required this.transactionsType,
    this.quantity,
    this.notes,
    super.createdAt,
    super.updatedAt,
  });

  factory Transactions.fromJson(Map<String, dynamic> json) =>
      _$TransactionsFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TransactionsToJson(this);
}

enum TransactionsType { sale, transfer, supply }
