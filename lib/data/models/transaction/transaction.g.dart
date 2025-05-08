// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transactions _$TransactionsFromJson(Map<String, dynamic> json) => Transactions(
      id: json['id'] as String,
      name: json['name'] as String,
      businessId: json['businessId'] as String?,
      productId: json['productId'] as String?,
      type: json['type'] as String?,
      transactionsType:
          $enumDecode(_$TransactionsTypeEnumMap, json['transactionsType']),
      quantity: json['quantity'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$TransactionsToJson(Transactions instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'type': instance.type,
      'productId': instance.productId,
      'businessId': instance.businessId,
      'transactionsType': _$TransactionsTypeEnumMap[instance.transactionsType]!,
      'quantity': instance.quantity,
      'notes': instance.notes,
    };

const _$TransactionsTypeEnumMap = {
  TransactionsType.sale: 'sale',
  TransactionsType.transfer: 'transfer',
  TransactionsType.supply: 'supply',
};
