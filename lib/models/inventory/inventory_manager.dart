import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_mate/models/unit_system/unit_sytem.dart';
import 'package:shop_mate/repositories/inventory_repository.dart';

class InventoryManager {
  final UnitSystem _unitSystem;
  final InventoryRepository _repository;

  InventoryManager(
      {required UnitSystem unitSystem, required InventoryRepository repository,})
      : _unitSystem = unitSystem,
        _repository = repository;


}
