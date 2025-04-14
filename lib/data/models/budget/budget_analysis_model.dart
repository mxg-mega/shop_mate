class BudgetAnalysis {
  final Map<String, double> budgeted;
  final Map<String, double> actual;
  final Map<String, double> variance;

  BudgetAnalysis({
    required this.budgeted,
    required this.actual,
    required this.variance,
  });

  factory BudgetAnalysis.fromJson(Map<String, dynamic> json) => BudgetAnalysis(
        budgeted: Map<String, double>.from(json['budgeted']),
        actual: Map<String, double>.from(json['actual']),
        variance: Map<String, double>.from(json['variance']),
      );

  Map<String, dynamic> toJson() => {
        'budgeted': budgeted,
        'actual': actual,
        'variance': variance,
      };
}
