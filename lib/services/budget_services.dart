import 'package:shop_mate/models/budget/budget_model.dart';
import 'package:shop_mate/repositories/budget_repository.dart';

class BudgetService {
  final BudgetRepository _budgetRepo;

  BudgetService(this._budgetRepo);

  Future<void> createBudget(Budget budget) async {
    await _budgetRepo.createBudget(budget);
  }

  Future<Budget?> getBudgetById(String businessId, String budgetId) async {
    return await _budgetRepo.getBudgetById(businessId, budgetId);
  }

  Future<void> updateBudget(String businessId, String budgetId, Map<String, dynamic> updates) async {
    await _budgetRepo.updateBudget(businessId, budgetId, updates);
  }

  Future<void> deleteBudget(String businessId, String budgetId) async {
    await _budgetRepo.deleteBudget(businessId, budgetId);
  }

  Future<List<Budget>> getBudgetsForPeriod(String businessId, DateTime startDate, DateTime endDate) async {
    return await _budgetRepo.getBudgetsForPeriod(businessId, startDate, endDate: endDate);
  }

  Stream<List<Budget>> streamBudgets(String businessId) {
    return _budgetRepo.streamBudgets(businessId);
  }
}
