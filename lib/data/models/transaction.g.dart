// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      id: json['id'] as String,
      name: json['name'] as String,
      businessID: json['businessID'] as String?,
      productID: json['productID'] as String?,
      type: json['type'] as String?,
      transactionType:
          $enumDecode(_$TransactionTypeEnumMap, json['transactionType']),
      quantity: json['quantity'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'type': instance.type,
      'productID': instance.productID,
      'businessID': instance.businessID,
      'transactionType': _$TransactionTypeEnumMap[instance.transactionType]!,
      'quantity': instance.quantity,
      'notes': instance.notes,
    };

const _$TransactionTypeEnumMap = {
  TransactionType.sale: 'sale',
  TransactionType.transfer: 'transfer',
  TransactionType.supply: 'supply',
};
