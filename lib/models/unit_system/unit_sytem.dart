import 'package:shop_mate/models/unit_system/unit_conversion.dart';
import 'package:shop_mate/models/unit_system/units_model.dart';

class UnitSystem {
  final String name;
  final Map<String, Unit> units;
  final Map<String, UnitConversion> conversions;

  static final Map<String, Unit> defaultUnits = {
    'unit': Unit(name: 'unit', symbol: 'unit', conversionRate: 1),
    'box': Unit(name: 'box', symbol: 'box', conversionRate: 10),
    'kg': Unit(name: 'kg', symbol: 'kg', conversionRate: 1),
    'g': Unit(name: 'g', symbol: 'g', conversionRate: 1000),
    'lb': Unit(name: 'lb', symbol: 'lb', conversionRate: 2.20462),
  };

  static final Map<String, UnitConversion> defaultConversions = {
    'unit-box': UnitConversion(
      fromUnit: defaultUnits['unit']!,
      toUnit: defaultUnits['box']!,
      conversionRate: 10,
    ),
    'kg-g': UnitConversion(
      fromUnit: defaultUnits['kg']!,
      toUnit: defaultUnits['g']!,
      conversionRate: 1000,
    ),
    'kg-lb': UnitConversion(
      fromUnit: defaultUnits['kg']!,
      toUnit: defaultUnits['lb']!,
      conversionRate: 2.20462,
    ),
  };

  UnitSystem({
    required this.name,
    required this.units,
    required this.conversions,
  });

  factory UnitSystem.defaultSystem() {
    return UnitSystem(
      name: 'Default Unit System',
      units: defaultUnits,
      conversions: defaultConversions,
    );
  }

  void addOrUpdateUnit(Unit unit) {
    units[unit.name] = unit;
  }

  void addOrUpdateConversion(UnitConversion conversion) {
    final key = '${conversion.fromUnit.name}-${conversion.toUnit.name}';
    conversions[key] = conversion;
  }

  UnitConversion? getConversion(String fromUnit, String toUnit) {
    final key = '$fromUnit-$toUnit';
    return conversions[key];
  }

  factory UnitSystem.fromJson(Map<String, dynamic> json) {
    return UnitSystem(
      name: json['name'] as String,
      units: (json['units'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, Unit.fromJson(value)),
      ),
      conversions: (json['conversions'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, UnitConversion.fromJson(value)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'units': units.map((key, value) => MapEntry(key, value.toJson())),
      'conversions': conversions.map((key, value) => MapEntry(key, value.toJson())),
    };
  }
}
