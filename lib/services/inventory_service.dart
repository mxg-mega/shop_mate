import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_mate/core/error/inventory_exceptions.dart';
import 'package:shop_mate/core/utils/constants.dart';
import 'package:shop_mate/models/inventory/inventory_cache_manager.dart';
import 'package:shop_mate/models/inventory/inventory_item_model.dart';
import 'package:shop_mate/models/inventory/inventory_model.dart';
import 'package:shop_mate/models/unit_system/unit_sytem.dart';
import 'package:shop_mate/repositories/inventory_repository.dart';

class InventoryService {
  final InventoryRepository _repository;
  final UnitSystem _unitSystem;
  final InventoryCache _cache;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  InventoryService({
    required UnitSystem unitSystem,
    required InventoryRepository repository,
  })  : _unitSystem = unitSystem,
        _repository = repository,
        _cache = InventoryCache();

  Future<void> transferStock({
    required String productId,
    required String fromLocation,
    required String toLocation,
    required double amount,
    required String unit,
  }) async {
    // Ensure atomic operation
    final batch = _firestore.batch();

    final fromItem = await _repository.getInventoryItemById(productId);
    final toItem = await _repository.getInventoryItemById(productId);

    if (fromItem == null) throw Exception('Source inventory item not found');

    // Convert to base unit
    final conversion = _unitSystem.getConversion(unit, fromItem.baseUnit);
    if (conversion == null) throw Exception('Invalid unit conversion');

    final baseAmount = amount * conversion.conversionRate;

    // Validate stock
    if (fromItem.quantity < baseAmount) {
      throw Exception('Insufficient stock for transfer');
    }

    // Update both locations
    batch.update(
      _repository.getDocumentReference(fromItem.id),
      {'quantity': fromItem.quantity - baseAmount},
    );

    if (toItem != null) {
      batch.update(
        _repository.getDocumentReference(toItem.id),
        {'quantity': toItem.quantity + baseAmount},
      );
    } else {
      // Create new inventory item at destination
      final newItem = fromItem.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        location: toLocation,
        quantity: baseAmount.toInt(),
      );
      batch.set(
        _repository.getDocumentReference(newItem.id),
        newItem.toJson(),
      );
    }

    await batch.commit();
  }

  Future<void> addStock(String productId, int amount, String unit) async {
    final item = await _repository.getInventoryItemById(productId);
    if (item == null) throw Exception('Inventory item not found.');

    // Convert to base unit
    final conversion = _unitSystem.getConversion(unit, item.baseUnit);
    if (conversion == null) throw Exception('Invalid unit conversion.');

    final convertedAmount = amount * conversion.conversionRate;

    final updatedItem = item.copyWith(
      quantity: item.quantity + convertedAmount.toInt(),
      status: InventoryItem.calculateStatus(
          item.quantity + convertedAmount.toInt()),
    );
    await _repository.updateInventoryItem(productId, updatedItem.toJson());
  }

  Future<void> reduceStock(String productId, int amount, String unit) async {
    final item = await _repository.getInventoryItemById(productId);
    if (item == null) throw Exception('Inventory item not found.');

    // Convert to base unit
    final conversion = _unitSystem.getConversion(unit, item.baseUnit);
    if (conversion == null) throw Exception('Invalid unit conversion.');

    final convertedAmount = amount * conversion.conversionRate;

    if (item.quantity < amount) throw Exception('Insufficient stock.');

    final updatedItem = item.copyWith(
      quantity: item.quantity - convertedAmount.toInt(),
      status: InventoryItem.calculateStatus(
          item.quantity - convertedAmount.toInt()),
    );
    await _repository.updateInventoryItem(productId, updatedItem.toJson());
  }

  Future<Inventory> getInventoryValue(String bizId) async {
    final listOfInventoryItems = _repository.streamInventoryItems();

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

  Future<InventoryItem> getInventoryItem(String id) async {
    final cachedItem = _cache.getItem(id);
    if (cachedItem != null){
      return cachedItem;
    }

    final item = await _repository.getInventoryItemById(id);
    if (item == null){
      throw InventoryException('Inventory item not found', code: 'ITEM_NOT_FOUND');
    }

    _cache.cacheItem(item);
    return item;
  }

  Future<void> createInventoryItem(InventoryItem item) async {
    await _repository.createInventoryItem(item);
  }

  Future<InventoryItem?> getInventoryItemById(String id) async {
    return await _repository.getInventoryItemById(id);
  }

  Future<void> updateInventoryItem(
      String id, Map<String, dynamic> updates) async {
    await _repository.updateInventoryItem(id, updates);
  }

  Future<void> deleteInventoryItem(String id) async {
    await _repository.deleteInventoryItem(id);
  }

  Stream<List<InventoryItem>> streamInventoryItems() {
    return _repository.streamInventoryItems();
  }

  Future<List<InventoryItem>> getInventoryItemsPaginated({
    required int limit,
    DocumentSnapshot? startAfter,
  }) async {
    return await _repository.getInventoryItemsPaginated(
        limit: limit, startAfter: startAfter);
  }
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