import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_mate/core/error/inventory_exceptions.dart';
import 'package:shop_mate/core/utils/constants.dart';
import 'package:shop_mate/data/models/inventory/inventory_item_model.dart';
import 'package:shop_mate/services/business_service.dart';
import 'package:shop_mate/services/firebase_CRUD_service.dart';

class InventoryRepository {
  static final InventoryRepository _instance = InventoryRepository._internal();
  factory InventoryRepository() => _instance;

  final FirebaseCRUDService<InventoryItem> _firebaseService;
  final BusinessService _businessService = BusinessService.instance;

  InventoryRepository._internal()
      : _firebaseService = FirebaseCRUDService<InventoryItem>(
          collectionName: Storage.inventory,
          fromJson: (data) => InventoryItem.fromJson(data),
        ) {
    if (_businessService.businessId == null) {
      throw InventoryException('No business selected', code: 'no-business');
    }
  }

  CollectionReference getCollection() {
    return _firebaseService.collection;
  }

  DocumentReference getDocumentReference(String id) {
    try {
      return _firebaseService.getDocRef(id);
    } catch (e) {
      throw InventoryException('Inventory Repo: ${e.toString()}',
          code: 'Doc Not Found');
    }
  }

  Future<void> createInventoryItem(InventoryItem item) async {
    try {
      await _firebaseService.create(item);
    } catch (e) {
      rethrow;
    }
  }

  Future<InventoryItem?> getInventoryItemById(String id) async {
    try {
      return await _firebaseService.read(id);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateInventoryItem(
      String id, Map<String, dynamic> updates) async {
    try {
      await _firebaseService.update(id, updates: updates);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteInventoryItem(String id) async {
    try {
      await _firebaseService.delete(id);
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<InventoryItem>> streamInventoryItems() {
    try {
      return _firebaseService.streamAll();
    } catch (e) {
      logger.e('repository: $e');
      rethrow;
    }
  }

  Future<List<InventoryItem>> getInventoryItemsPaginated({
    required int limit,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      return await _firebaseService.getPaginated(
          limit: limit, startAfter: startAfter);
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
