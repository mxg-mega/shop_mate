import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_mate/data/models/expenses/expense_model.dart';
import 'package:shop_mate/core/utils/constants.dart';

class ExpenseRepository {
  final FirebaseFirestore _firestore;

  ExpenseRepository(this._firestore);

  Future<List<Expense>> getForPeriod(
    String businessId,
    DateTime startDate, {
    DateTime? endDate,
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
          snapshot.docs.map((doc) => Expense.fromJson(doc.data())).toList();

      return sales;
    } catch (e) {
      // Handle error
      throw Exception('Failed to retrieve Expense transactions: $e');
    }
  }

  Stream<List<Expense>> streamExpenses(String businessId) {
    return _firestore
        .collection(Storage.businesses)
        .doc(businessId)
        .collection(Storage.expenses)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Expense.fromFirestore(doc)).toList());
  }

  Future<void> createExpense(Expense expense) async {
    await _firestore
        .collection(Storage.businesses)
        .doc(expense.businessId)
        .collection(Storage.expenses)
        .doc(expense.id)
        .set(expense.toJson());
  }

  Future<void> updateExpense(
      String businessId, String expenseId, Map<String, dynamic> updates) async {
    await _firestore
        .collection(Storage.businesses)
        .doc(businessId)
        .collection(Storage.expenses)
        .doc(expenseId)
        .update(updates);
  }

  Future<void> deleteExpense(String businessId, String expenseId) async {
    await _firestore
        .collection(Storage.businesses)
        .doc(businessId)
        .collection(Storage.expenses)
        .doc(expenseId)
        .delete();
  }
}
