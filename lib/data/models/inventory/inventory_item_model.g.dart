// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventoryItem _$InventoryItemFromJson(Map<String, dynamic> json) =>
    InventoryItem(
      productId: json['productId'] as String,
      businessId: json['businessId'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      status: $enumDecode(_$InventoryStatusEnumMap, json['status']),
      costPrice: (json['costPrice'] as num).toDouble(),
      salesPrice: (json['salesPrice'] as num).toDouble(),
      location: json['location'] as String?,
      hasExpiryDate: json['hasExpiryDate'] as bool? ?? false,
      expiryDate: json['expiryDate'] == null
          ? null
          : DateTime.parse(json['expiryDate'] as String),
      notes: json['notes'] as String?,
      baseUnit: json['baseUnit'] as String,
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$InventoryItemToJson(InventoryItem instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'productId': instance.productId,
      'businessId': instance.businessId,
      'quantity': instance.quantity,
      'status': _$InventoryStatusEnumMap[instance.status]!,
      'location': instance.location,
      'costPrice': instance.costPrice,
      'salesPrice': instance.salesPrice,
      'baseUnit': instance.baseUnit,
      'hasExpiryDate': instance.hasExpiryDate,
      'expiryDate': instance.expiryDate?.toIso8601String(),
      'notes': instance.notes,
    };

const _$InventoryStatusEnumMap = {
  InventoryStatus.inStock: 'inStock',
  InventoryStatus.lowStock: 'lowStock',
  InventoryStatus.onOrder: 'onOrder',
  InventoryStatus.outOfStock: 'outOfStock',
};
