import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_mate/core/utils/constants.dart';

class BusinessInitializer {
  final String businessId;
  final String ownerId;

  BusinessInitializer({
    required this.businessId,
    required this.ownerId,
  });

  Future<void> initialize() async {
    final batch = FirebaseFirestore.instance.batch();

    // Create business document
    final businessRef = FirebaseFirestore.instance
        .collection(Storage.businesses)
        .doc(businessId);

    batch.set(businessRef, {
      'id': businessId,
      'ownerId': ownerId,
      'createdAt': FieldValue.serverTimestamp(),
      'isActive': 'true',
      'subscription': {
        'plan': 'free',
        'features': ['basic_inventory', 'basic_sales'],
        'startDate': FieldValue.serverTimestamp(),
        'offlinePersistence': false,
      }
    });

    // Initialize default collections
    final collections = [
      'inventory',
      'sales',
      'expenses',
      'employees',
    ];

    for (final collection in collections) {
      final settingsRef = businessRef
          .collection(collection)
          .doc('settings');

      batch.set(settingsRef, {
        'initialized': true,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    // Create default categories
    final categoriesRef = businessRef.collection('categories');

    final defaultCategories = [
      {'name': 'General', 'type': 'expense'},
      {'name': 'Inventory', 'type': 'expense'},
      {'name': 'Sales', 'type': 'income'},
    ];

    for (final category in defaultCategories) {
      final docRef = categoriesRef.doc();
      batch.set(docRef, {
        'id': docRef.id,
        ...category,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }
}