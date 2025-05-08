import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_mate/core/utils/constants.dart';

/// This function updates all inventory items in the subcollection 'Inventory' of each 'Business'
/// by adding the fields 'hasExpiryDate' and 'expiryDate' with default values if they do not exist.
Future<void> addExpiryFieldsToInventoryItems() async {
  final firestore = FirebaseFirestore.instance;

  final businessesSnapshot = await firestore.collection(Storage.businesses).get();

  for (final businessDoc in businessesSnapshot.docs) {
    final inventoryCollection = businessDoc.reference.collection(Storage.inventory);

    final inventorySnapshot = await inventoryCollection.get();

    for (final inventoryDoc in inventorySnapshot.docs) {
      final data = inventoryDoc.data();

      final hasExpiryDateExists = data.containsKey('hasExpiryDate');
      final expiryDateExists = data.containsKey('expiryDate');

      if (!hasExpiryDateExists || !expiryDateExists) {
        await inventoryDoc.reference.update({
          'hasExpiryDate': data['hasExpiryDate'] ?? false,
          'expiryDate': data['expiryDate'] ?? null,
        });
      }
    }
  }
}


Future<void> addNotesField() async {
  final firestore = FirebaseFirestore.instance;

  final businessesSnapshot = await firestore.collection(Storage.businesses).get();

  for (final businessDoc in businessesSnapshot.docs) {
    final inventoryCollection = businessDoc.reference.collection(Storage.inventory);

    final inventorySnapshot = await inventoryCollection.get();

    for (final inventoryDoc in inventorySnapshot.docs) {
      final data = inventoryDoc.data();

      final notesExists = data.containsKey('notes');

      if (!notesExists ) {
        await inventoryDoc.reference.update({
          'notes': data['notes'] ?? null,
        });
      }
    }
  }
}

Future<void> deleteDocuments() async {
  final firestore = FirebaseFirestore.instance;

  final businessesSnapshot = await firestore.collection(Storage.businesses).get();

  for (final businessDoc in businessesSnapshot.docs) {
    final inventoryCollection = businessDoc.reference.collection(Storage.inventory);
    final productCollection = businessDoc.reference.collection(Storage.products);
    final transactionCollection = businessDoc.reference.collection(Storage.transactions);

    final inventorySnapshot = await inventoryCollection.get();
    final productSnapshot = await productCollection.get();
    final transactionSnapshot = await transactionCollection.get();

    for (final inventoryDoc in inventorySnapshot.docs) {
      await inventoryDoc.reference.delete();
    }

    for (final productDoc in productSnapshot.docs) {
      await productDoc.reference.delete();
    }

    for (final transactionDoc in transactionSnapshot.docs) {
      await transactionDoc.reference.delete();
    }
  }
}
