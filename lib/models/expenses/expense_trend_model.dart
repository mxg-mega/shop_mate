class ExpenseTrend {
  final String category;
  final double amount;
  final DateTime date;

  ExpenseTrend({
    required this.category,
    required this.amount,
    required this.date,
  });

  factory ExpenseTrend.fromJson(Map<String, dynamic> json) => ExpenseTrend(
        category: json['category'],
        amount: json['amount'].toDouble(),
        date: DateTime.parse(json['date']),
      );

  Map<String, dynamic> toJson() => {
        'category': category,
        'amount': amount,
        'date': date.toIso8601String(),
      };
}
