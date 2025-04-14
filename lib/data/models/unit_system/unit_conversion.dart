import 'package:shop_mate/data/models/unit_system/units_model.dart';

class UnitConversion {
  final Unit fromUnit;
  final Unit toUnit;
  double conversionRate;

  UnitConversion({
    required this.fromUnit,
    required this.toUnit,
    required this.conversionRate,
  });

  factory UnitConversion.fromJson(Map<String, dynamic> json) {
    return UnitConversion(
      fromUnit: Unit.fromJson(json['fromUnit']),
      toUnit: Unit.fromJson(json['toUnit']),
      conversionRate: json['conversionRate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fromUnit': fromUnit.toJson(),
      'toUnit': toUnit.toJson(),
      'conversionRate': conversionRate,
    };
  }

  static UnitConversion fromCSV(String csv) {
    final parts = csv.split(',');
    return UnitConversion(
      fromUnit: Unit.fromCSV(parts[0]),
      toUnit: Unit.fromCSV(parts[1]),
      conversionRate: double.parse(parts[2]),
    );
  }

  String toCSV() {
    return '${fromUnit.toCSV()},${toUnit.toCSV()},$conversionRate';
  }
}
