import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_mate/data/models/budget/budget_model.dart';
import 'package:shop_mate/core/utils/constants.dart';

class BudgetRepository {
  final FirebaseFirestore _firestore;

  BudgetRepository(this._firestore);

  Future<void> createBudget(Budget budget) async {
    await _firestore
        .collection(Storage.businesses)
        .doc(budget.businessId)
        .collection(Storage.budget)
        .doc(budget.id)
        .set(budget.toJson());
  }

  Future<Budget?> getBudgetById(String businessId, String budgetId) async {
    final doc = await _firestore
        .collection(Storage.businesses)
        .doc(businessId)
        .collection(Storage.budget)
        .doc(budgetId)
        .get();
    return doc.exists ? Budget.fromFirestore(doc) : null;
  }

  Future<void> updateBudget(
      String businessId, String budgetId, Map<String, dynamic> updates) async {
    await _firestore
        .collection(Storage.businesses)
        .doc(businessId)
        .collection(Storage.budget)
        .doc(budgetId)
        .update(updates);
  }

  Future<void> deleteBudget(String businessId, String budgetId) async {
    await _firestore
        .collection(Storage.businesses)
        .doc(businessId)
        .collection(Storage.budget)
        .doc(budgetId)
        .delete();
  }

  Future<List<Budget>> getBudgetsForPeriod(
    String businessId,
    DateTime startDate, {
    DateTime? endDate,
  }) async {
    try {
      final effectiveEndDate = endDate ?? DateTime.now();

      final budgetList = await _firestore
          .collection(Storage.businesses)
          .doc(businessId)
          .collection(Storage.budget)
          .where('periodStart', isGreaterThanOrEqualTo: startDate)
          .where('periodEnd', isLessThanOrEqualTo: effectiveEndDate)
          .get()
          .then((snapshot) =>
              snapshot.docs.map((doc) => Budget.fromFirestore(doc)).toList());

      return budgetList;
    } catch (e) {
      throw Exception("Failed to retrieve Budget transactions: $e");
    }
  }

  Stream<List<Budget>> streamBudgets(String businessId) {
    return _firestore
        .collection(Storage.businesses)
        .doc(businessId)
        .collection(Storage.budget)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Budget.fromFirestore(doc)).toList());
  }
}
