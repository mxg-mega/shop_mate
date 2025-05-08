import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_mate/core/utils/constants.dart';

class InventoryMigration {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Migrates quantity field from int to double in inventory items of all businesses.
  Future<void> migrateQuantityIntToDouble() async {
    final businessesSnapshot = await _firestore.collection(Storage.businesses).get();

    for (final businessDoc in businessesSnapshot.docs) {
      final businessId = businessDoc.id;
      final inventoryCollection = _firestore
          .collection(Storage.businesses)
          .doc(businessId)
          .collection(Storage.inventory);

      var batch = _firestore.batch();
      int updateCount = 0;

      final inventorySnapshot = await inventoryCollection.get();

      for (final inventoryDoc in inventorySnapshot.docs) {
        final data = inventoryDoc.data();
        final quantity = data['quantity'];

        if (quantity is int) {
          // Convert int quantity to double
          final doubleQuantity = quantity.toDouble();

          batch.update(inventoryDoc.reference, {'quantity': doubleQuantity});
          updateCount++;

          // Commit batch every 500 updates to avoid Firestore limits
          if (updateCount % 500 == 0) {
            await batch.commit();
            // Firestore WriteBatch does not have clear(), create a new batch instead
            // So we commit and create a new batch for further updates
            batch = _firestore.batch();
          }
        }
      }

      // Commit any remaining updates
      if (updateCount % 500 != 0) {
        await batch.commit();
      }
    }

    print('Migration completed: quantity fields converted from int to double.');
  }
}
