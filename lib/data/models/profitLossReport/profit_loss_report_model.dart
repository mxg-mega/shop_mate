class ProfitLossReport {
  final double revenue;
  final double costOfGoodsSold;
  final double grossProfit;
  final double operatingExpenses;
  final double netIncome;
  final double profitMargins;

  ProfitLossReport({
    required this.revenue,
    required this.costOfGoodsSold,
    required this.grossProfit,
    required this.operatingExpenses,
    required this.netIncome,
    required this.profitMargins,
  });

  factory ProfitLossReport.fromJson(Map<String, dynamic> json) {
    return ProfitLossReport(
      revenue: json['revenue'].toDouble(),
      costOfGoodsSold: json['costOfGoodsSold'].toDouble(),
      grossProfit: json['grossProfit'].toDouble(),
      operatingExpenses: json['operatingExpenses'].toDouble(),
      netIncome: json['netIncome'].toDouble(),
      profitMargins: json['profitMargins'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'revenue': revenue,
      'costOfGoodsSold': costOfGoodsSold,
      'grossProfit': grossProfit,
      'operatingExpenses': operatingExpenses,
      'netIncome': netIncome,
      'profitMargins': profitMargins,
    };
  }
}
