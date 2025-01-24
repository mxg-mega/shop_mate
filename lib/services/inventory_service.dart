import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_mate/core/utils/constants.dart';
import 'package:shop_mate/models/inventory/inventory_item_model.dart';
import 'package:shop_mate/models/inventory/inventory_model.dart';
import 'package:shop_mate/models/unit_system/unit_sytem.dart';
import 'package:shop_mate/repositories/inventory_repository.dart';

class InventoryService {
  final InventoryRepository _inventoryRepo;
  final UnitSystem unitSystem;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  InventoryService(this._inventoryRepo, {required this.unitSystem,});

  Future<void> addStock(String productId, int amount, String unit) async {
    final item = await _inventoryRepo.getInventoryItemById(productId);
    if (item == null) throw Exception('Inventory item not found.');

    // Convert to base unit
    final conversion = unitSystem.getConversion(unit, item.baseUnit);
    if (conversion == null) throw Exception('Invalid unit conversion.');

    final convertedAmount = amount * conversion.conversionRate;
    
    final updatedItem = item.copyWith(
      quantity: item.quantity + convertedAmount.toInt(),
      status: InventoryItem.calculateStatus(item.quantity + convertedAmount.toInt()),
    );
    await _inventoryRepo.updateInventoryItem(productId, updatedItem.toJson());
  }

  Future<void> reduceStock(String productId, int amount, String unit) async {
    final item = await _inventoryRepo.getInventoryItemById(productId);
    if (item == null) throw Exception('Inventory item not found.');

    // Convert to base unit
    final conversion = unitSystem.getConversion(unit, item.baseUnit);
    if (conversion == null) throw Exception('Invalid unit conversion.');

    final convertedAmount = amount * conversion.conversionRate;

    if (item.quantity < amount) throw Exception('Insufficient stock.');

    final updatedItem = item.copyWith(
      quantity: item.quantity - convertedAmount.toInt(),
      status: InventoryItem.calculateStatus(item.quantity - convertedAmount.toInt()),
    );
    await _inventoryRepo.updateInventoryItem(productId, updatedItem.toJson());
  }

  Future<Inventory> getInventoryValue(String bizId) async {
    final listOfInventoryItems = _inventoryRepo.streamInventoryItems();

    return Inventory(items: listOfInventoryItems as List<InventoryItem>);
  }

  Future<Inventory> getInventoryTransactions(
    String businessId,
    DateTime startDate, {
    DateTime? endDate, // Make endDate optional and nullable
  }) async {
    try {
      // If endDate is not provided, default to the current time
      final effectiveEndDate = endDate ?? DateTime.now();

      final query = _firestore
          .collection(Storage.businesses)
          .doc(businessId)
          .collection(Storage.inventory)
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThanOrEqualTo: effectiveEndDate);

      final snapshot = await query.get();
      final inventoryItems = snapshot.docs
          .map((doc) => InventoryItem.fromJson(doc.data()))
          .toList();

      return Inventory(items: inventoryItems);
    } catch (e) {
      // Handle error
      throw Exception('Failed to retrieve inventory transactions: $e');
    }
  }

  Future<void> createInventoryItem(InventoryItem item) async {
    await _inventoryRepo.createInventoryItem(item);
  }

  Future<InventoryItem?> getInventoryItemById(String id) async {
    return await _inventoryRepo.getInventoryItemById(id);
  }

  Future<void> updateInventoryItem(
      String id, Map<String, dynamic> updates) async {
    await _inventoryRepo.updateInventoryItem(id, updates);
  }

  Future<void> deleteInventoryItem(String id) async {
    await _inventoryRepo.deleteInventoryItem(id);
  }

  Stream<List<InventoryItem>> streamInventoryItems() {
    return _inventoryRepo.streamInventoryItems();
  }

  Future<List<InventoryItem>> getInventoryItemsPaginated({
    required int limit,
    DocumentSnapshot? startAfter,
  }) async {
    return await _inventoryRepo.getInventoryItemsPaginated(
        limit: limit, startAfter: startAfter);
  }
}
