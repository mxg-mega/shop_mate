
import 'package:shop_mate/models/base_model.dart';

class InventoryItem extends BaseModel {
  final double productId;
  final String productName;
  final int productQuantity;

  InventoryItem({
    required this.productId,
    required this.productName,
    required this.productQuantity, required super.name, required super.id,
  });

  void convertToJson(InventoryItem item) {
    print("${item.toString()}");
  }
}
