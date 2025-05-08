import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/data/models/products/product_model.dart';
import 'package:shop_mate/providers/inventory_provider.dart';

class ViewProductScreen extends StatefulWidget {
  const ViewProductScreen({super.key, required this.product});

  final Product product;

  @override
  _ViewProductScreenState createState() => _ViewProductScreenState();
}

class _ViewProductScreenState extends State<ViewProductScreen> {
  @override
  Widget build(BuildContext context) {
    final inventoryProvider = Provider.of<InventoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: ShadButton.ghost(
          child: Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.product.name),
      ),
      body: Placeholder(),
    );
  }
}
