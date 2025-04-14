import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/providers/inventory_provider.dart';
import 'package:shop_mate/data/models/inventory/inventory_item_model.dart';

class ViewProductScreen extends StatefulWidget {
  const ViewProductScreen({super.key, required this.item});

  final InventoryItem item;

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
        title: Text(widget.item.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Product ID: ${widget.item.id}'),
            Text('Quantity: ${widget.item.quantity}'),
            Text('Cost Price: N${widget.item.costPrice}'),
            Text('Sales Price: N${widget.item.salesPrice}'),
            Text('Location: ${widget.item.location ?? 'N/A'}'),
            Text('Base Unit: ${widget.item.baseUnit}'),
            Text('Status: ${widget.item.status.name}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigator.pushNamed(context, '/editProduct',
                //     arguments: widget.productId);
              },
              child: Text('Edit Product'),
            ),
            ElevatedButton(
              onPressed: () {
                inventoryProvider.deleteInventoryItem(widget.item);
                Navigator.pop(context);
              },
              child: Text('Delete Product'),
            ),
          ],
        ),
      ),
    );
  }
}
