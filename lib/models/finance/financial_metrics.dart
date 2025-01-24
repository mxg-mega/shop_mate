class FinancialMetrics {
  final double totalExpenses;
  final double fixedExpenses;
  final double variableExpenses;
  final double grossProfit;
  final double netProfit;
  final double operatingMargin;
  final double cashFlow;
  final double inventoryTurnover;
  final Map<String, double> expenseByCategory;

  FinancialMetrics({
    required this.totalExpenses,
    required this.fixedExpenses,
    required this.variableExpenses,
    required this.grossProfit,
    required this.netProfit,
    required this.operatingMargin,
    required this.cashFlow,
    required this.inventoryTurnover,
    required this.expenseByCategory,
  });

  factory FinancialMetrics.fromJson(Map<String, dynamic> json) {
    return FinancialMetrics(
      totalExpenses: json['totalExpenses'].toDouble(),
      fixedExpenses: json['fixedExpenses'].toDouble(),
      variableExpenses: json['variableExpenses'].toDouble(),
      grossProfit: json['grossProfit'].toDouble(),
      netProfit: json['netProfit'].toDouble(),
      operatingMargin: json['operatingMargin'].toDouble(),
      cashFlow: json['cashFlow'].toDouble(),
      inventoryTurnover: json['inventoryTurnover'].toDouble(),
      expenseByCategory: Map<String, double>.from(json['expenseByCategory']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalExpenses': totalExpenses,
      'fixedExpenses': fixedExpenses,
      'variableExpenses': variableExpenses,
      'grossProfit': grossProfit,
      'netProfit': netProfit,
      'operatingMargin': operatingMargin,
      'cashFlow': cashFlow,
      'inventoryTurnover': inventoryTurnover,
      'expenseByCategory': expenseByCategory,
    };
  }
}
