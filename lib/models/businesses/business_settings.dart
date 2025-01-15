import 'package:shop_mate/models/unit_system/unit_sytem.dart';

class BusinessSettings {
  final String businessId;
  final String currency;
  final String timezone;
  final UnitSystem defaultUnitSystem;
  final List<String> additionalUnitSystems;
  // final Map<String, PermissionLevel> defaultPermissions;

  BusinessSettings(this.currency, this.timezone, this.defaultUnitSystem, this.additionalUnitSystems, this.businessId);

}