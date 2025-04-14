class Unit {
  final String name;
  final String symbol;
  final double conversionRate;

  set name(value) => name = value;
  set symbol(value) => symbol = value;
  set conversionRate(value) => conversionRate = value;

  Unit({
    required this.name,
    required this.symbol,
    required this.conversionRate,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      name: json['name'],
      symbol: json['symbol'],
      conversionRate: json['conversionRate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'symbol': symbol,
      'conversionRate': conversionRate,
    };
  }

  static Unit fromCSV(String csv) {
    final parts = csv.split(',');
    return Unit(
      name: parts[0],
      symbol: parts[1],
      conversionRate: double.parse(parts[2]),
    );
  }

  String toCSV() {
    return '$name,$symbol,$conversionRate';
  }

  Unit copyWith({
    String? name,
    String? symbol,
    double? conversionRate,
  }) {
    return Unit(
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      conversionRate: conversionRate ?? this.conversionRate,
    );
  }
}
