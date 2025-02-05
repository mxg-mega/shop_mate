import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_mate/core/error/inventory_exceptions.dart';
import 'package:shop_mate/core/utils/constants.dart';
import 'package:shop_mate/models/inventory/inventory_cache_manager.dart';
import 'package:shop_mate/models/inventory/inventory_item_model.dart';
import 'package:shop_mate/models/inventory/inventory_model.dart';
import 'package:shop_mate/models/unit_system/unit_sytem.dart';
import 'package:shop_mate/repositories/inventory_repository.dart';
import 'package:shop_mate/services/base_firebase_service.dart';

class InventoryServiceUpdated extends BaseFirebaseService {

  InventoryServiceUpdated({required super.businessId, super.isSubCollection = true});

  @override
  String get collectionName => Storage.inventory;

  @override
  InventoryItem fromJson(Map<String, dynamic> json) => InventoryItem.fromJson(json);






}

// Extension on InventoryItem to add business logic
extension InventoryItemExtension on InventoryItem {
  bool hasShortage(double requiredAmount) {
    return quantity < requiredAmount;
  }

  bool needsReorder(double reorderPoint) {
    return quantity <= reorderPoint;
  }

  double get valueOfStock => quantity * costPrice;

  double get potentialRevenue => quantity * salesPrice;

  double get potentialProfit => potentialRevenue - (quantity * costPrice);
}