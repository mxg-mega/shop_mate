import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_mate/models/sales/sales.dart';
import 'package:shop_mate/services/firebase_services.dart';
import 'package:shop_mate/core/utils/constants.dart';

class SalesRepository {
  final MyFirebaseService<Sale> _firebaseService = MyFirebaseService<Sale>(
    collectionName: Storage.sales,
    fromJson: (data) => Sale.fromJson(data),
  );

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Sale>> getForPeriod(
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
          .collection(Storage.sales)
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThanOrEqualTo: effectiveEndDate);

      final snapshot = await query.get();
      final sales =
          snapshot.docs.map((doc) => Sale.fromJson(doc.data())).toList();

      return sales;
    } catch (e) {
      // Handle error
      throw Exception('Failed to retrieve Sales transactions: $e');
    }
  }

  Future<void> createSale(Sale sale) async {
    await _firebaseService.create(sale);
  }

  Future<Sale?> getSaleById(String id) async {
    return await _firebaseService.read(id);
  }

  Future<void> updateSale(String id, Map<String, dynamic> updates) async {
    await _firebaseService.update(id, updates);
  }

  Future<void> deleteSale(String id) async {
    await _firebaseService.delete(id);
  }

  Stream<List<Sale>> streamSales() {
    return _firebaseService.list();
  }

  Future<List<Sale>> getSalesPaginated({
    required int limit,
    DocumentSnapshot? startAfter,
  }) async {
    return await _firebaseService.paginatedList(
        limit: limit, startAfter: startAfter);
  }
}
