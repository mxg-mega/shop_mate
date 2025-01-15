import 'package:shop_mate/models/unit_system/unit_conversion.dart';

class UnitSystem {
  final String name; // e.g., "Weight-based", "Unit-based", "Box-based"
  final List<UnitConversion> conversions;
  final String baseUnit;
  final Map<String, double> conversionRates;

  UnitSystem(this.name, this.conversions, this.baseUnit, this.conversionRates);
}