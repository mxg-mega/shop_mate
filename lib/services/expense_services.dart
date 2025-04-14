import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/data/datasource/repositories/budget_repository.dart';
import 'package:shop_mate/data/datasource/repositories/expense_repository.dart';
import 'package:shop_mate/data/datasource/repositories/sales_repository.dart';
import 'package:shop_mate/data/models/budget/budget_analysis_model.dart';
import 'package:shop_mate/data/models/expenses/expense_model.dart';
import 'package:shop_mate/data/models/finance/financial_metrics.dart';
import 'package:shop_mate/data/models/inventory/inventory_model.dart';
import 'package:shop_mate/data/models/sales/sales.dart';
import 'package:shop_mate/services/analytics_service.dart';
import 'package:shop_mate/services/inventory_service.dart';

class ExpenseService {
  final ExpenseRepository _expenseRepo;
  final AnalyticsService _analyticsService;
  final InventoryService _inventoryService;
  final SalesRepository _salesRepo;
  final BudgetRepository _budgetRepo;
  // final NotificationService _notificationService;

  ExpenseService({
    required ExpenseRepository expenseRepo,
    required AnalyticsService analyticsService,
    required InventoryService inventoryService,
    required SalesRepository salesRepo,
    required BudgetRepository budgetRepo,
    // required NotificationService notificationService,
  })  : _expenseRepo = expenseRepo,
        _analyticsService = analyticsService,
        _inventoryService = inventoryService,
        // _notificationService = notificationService,
        _salesRepo = salesRepo,
        _budgetRepo = budgetRepo;

  Future<void> createExpense(Expense expense) async {
    await _expenseRepo.createExpense(expense);
    await Future.wait([
      _updateAnalytics(expense),
      _updateInventory(expense),
      _updateCashFlow(expense),
      _notifyRelevantParties(expense),
    ]);
  }

  Future<void> _updateAnalytics(Expense expense) async {
    // Update analytics based on the new expense
  }

  Future<void> _updateInventory(Expense expense) async {
    // Update inventory based on the new expense
  }

  Future<void> _updateCashFlow(Expense expense) async {
    // Update cash flow based on the new expense
  }

  Future<void> _notifyRelevantParties(Expense expense) async {
    // Notify relevant parties about the new expense
  }

  Future<List<Expense>> getExpensesForPeriod(
      String businessId, DateTime startDate, DateTime endDate) async {
    return await _expenseRepo.getForPeriod(businessId, startDate,
        endDate: endDate);
  }

  Future<FinancialMetrics> calculateFinancialMetrics({
    required String businessId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    // Get all relevant data
    final expenses = await _expenseRepo.getForPeriod(businessId, startDate,
        endDate: endDate);
    final sales =
        await _salesRepo.getForPeriod(businessId, startDate, endDate: endDate);
    final inventory = await _inventoryService.getInventoryValue(businessId);

    // Calculate metrics
    final metrics = FinancialMetrics(
      totalExpenses: _calculateTotalExpenses(expenses),
      fixedExpenses: _calculateFixedExpenses(expenses),
      variableExpenses: _calculateVariableExpenses(expenses),
      grossProfit: _calculateGrossProfit(sales, expenses),
      netProfit: _calculateNetProfit(sales, expenses),
      operatingMargin: _calculateOperatingMargin(sales, expenses),
      cashFlow: _calculateCashFlow(sales, expenses),
      inventoryTurnover: _calculateInventoryTurnover(sales, inventory),
      expenseByCategory: _groupExpensesByCategory(expenses),
    );

    // Update analytics
    await _analyticsService.updateFinancialMetrics(metrics);

    return metrics;
  }

  Future<BudgetAnalysis> analyzeBudgetVariance({
    required String businessId,
    required DateTime period,
  }) async {
    final budget = await _budgetRepo.getBudgetsForPeriod(businessId, period);
    final actualExpenses = await _expenseRepo.getForPeriod(
      businessId,
      period.startOfMonth,
      endDate: period.endOfMonth,
    );
    final budgeted =
        budget.map((budget) => budget.plannedExpenses) as Map<String, double>;

    return BudgetAnalysis(
      budgeted: budgeted,
      actual: _groupExpensesByCategory(actualExpenses),
      variance: _calculateVariance(budgeted, actualExpenses),
    );
  }

  // Private methods for calculating financial metrics
  double _calculateTotalExpenses(List<Expense> expenses) {
    return expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  double _calculateFixedExpenses(List<Expense> expenses) {
    return expenses
        .where((expense) => expense.type == ExpenseType.fixed)
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }

  double _calculateVariableExpenses(List<Expense> expenses) {
    return expenses
        .where((expense) => expense.type == ExpenseType.variable)
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }

  double _calculateGrossProfit(List<Sale> sales, List<Expense> expenses) {
    final totalRevenue = sales.fold(0.0, (sum, sale) => sum + sale.total);
    final totalCostOfGoodsSold = expenses
        .where((expense) => expense.category.affectsCogs)
        .fold(0.0, (sum, expense) => sum + expense.amount);
    return totalRevenue - totalCostOfGoodsSold;
  }

  double _calculateNetProfit(List<Sale> sales, List<Expense> expenses) {
    final grossProfit = _calculateGrossProfit(sales, expenses);
    final totalOperatingExpenses = _calculateTotalExpenses(expenses);
    return grossProfit - totalOperatingExpenses;
  }

  double _calculateOperatingMargin(List<Sale> sales, List<Expense> expenses) {
    final totalRevenue = sales.fold(0.0, (sum, sale) => sum + sale.total);
    final netProfit = _calculateNetProfit(sales, expenses);
    return netProfit / totalRevenue;
  }

  double _calculateCashFlow(List<Sale> sales, List<Expense> expenses) {
    final totalRevenue = sales.fold(0.0, (sum, sale) => sum + sale.total);
    final totalExpenses = _calculateTotalExpenses(expenses);
    return totalRevenue - totalExpenses;
  }

  double _calculateInventoryTurnover(List<Sale> sales, Inventory inventory) {
    final totalCostOfGoodsSold =
        sales.fold(0.0, (sum, sale) => sum + sale.totalCostPrice);
    final averageInventory = inventory.averageValue;
    return totalCostOfGoodsSold / averageInventory;
  }

  Map<String, double> _groupExpensesByCategory(List<Expense> expenses) {
    final Map<String, double> groupedExpenses = {};
    for (final expense in expenses) {
      groupedExpenses[expense.category.id] =
          (groupedExpenses[expense.category.id] ?? 0) + expense.amount;
    }
    return groupedExpenses;
  }

  Map<String, double> _calculateVariance(
      Map<String, double> plannedExpenses, List<Expense> actualExpenses) {
    final Map<String, double> variance = {};
    for (final entry in plannedExpenses.entries) {
      final actualAmount = actualExpenses
          .where((expense) => expense.category.id == entry.key)
          .fold(0.0, (sum, expense) => sum + expense.amount);
      variance[entry.key] = actualAmount - entry.value;
    }
    return variance;
  }
}
