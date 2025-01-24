import 'package:shop_mate/models/unit_system/unit_conversion.dart';
import 'package:shop_mate/models/unit_system/unit_sytem.dart';
import 'package:shop_mate/models/unit_system/units_model.dart';

class UnitSystemService {
  final UnitSystem unitSystem;

  UnitSystemService(this.unitSystem);

  /// Add or update a unit
  void addUnit(String name, double conversionRate) {
    if (unitSystem.units.containsKey(name)) {
      throw Exception('Unit already exists.');
    }
    unitSystem.addOrUpdateUnit(Unit(name: name,symbol: name, conversionRate: conversionRate));
  }

  /// Add or update a conversion
  void addConversion(String fromUnit, String toUnit, double conversionRate) {
    if (unitSystem.getConversion(fromUnit, toUnit) != null) {
      throw Exception('Conversion already exists.');
    }
    unitSystem.addOrUpdateConversion(
      UnitConversion(
        fromUnit: unitSystem.units[fromUnit]!,
        toUnit: unitSystem.units[toUnit]!,
        conversionRate: conversionRate,
      ),
    );
  }

  /// Remove a unit
  void removeUnit(String name) {
    if (!unitSystem.units.containsKey(name)) {
      throw Exception('Unit does not exist.');
    }
    unitSystem.units.remove(name);
  }

  /// Get conversion rate between units
  double? getConversionRate(String fromUnit, String toUnit) {
    return unitSystem.getConversion(fromUnit, toUnit)?.conversionRate;
  }
}
