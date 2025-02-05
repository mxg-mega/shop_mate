import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_mate/models/inventory/inventory_item_model.dart';
import 'package:shop_mate/services/firebase_services.dart';
import 'package:shop_mate/core/utils/constants.dart';

class InventoryRepository {
  final MyFirebaseService<InventoryItem> _firebaseService = MyFirebaseService<InventoryItem>(
    collectionName: Storage.inventory,
    fromJson: (data) => InventoryItem.fromJson(data),
  );

  final FirebaseFirestore _firestore;
  InventoryRepository() : _firestore = FirebaseFirestore.instance;

  DocumentReference getDocumentReference(String id){
    return _firebaseService.getDocRef(id);
  }

  Future<void> createInventoryItem(InventoryItem item) async {
    await _firebaseService.create(item);
  }

  Future<InventoryItem?> getInventoryItemById(String id) async {
    return await _firebaseService.read(id);
  }

  Future<void> updateInventoryItem(String id, Map<String, dynamic> updates) async {
    await _firebaseService.update(id, updates);
  }

  Future<void> deleteInventoryItem(String id) async {
    await _firebaseService.delete(id);
  }

  Stream<List<InventoryItem>> streamInventoryItems() {
    return _firebaseService.list();
  }

  Future<List<InventoryItem>> getInventoryItemsPaginated({
    required int limit,
    DocumentSnapshot? startAfter,
  }) async {
    return await _firebaseService.paginatedList(limit: limit, startAfter: startAfter);
  }
}
