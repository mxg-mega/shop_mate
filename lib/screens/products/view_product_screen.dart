import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/data/models/products/product_model.dart';
import 'package:shop_mate/providers/inventory_provider.dart';
import 'package:shop_mate/providers/product_provider.dart';

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
    final productProv = Provider.of<ProductProvider>(context);
    final theme = ShadTheme.of(context);

    Color textColor;
    Color? backgroundColor;
    switch (widget.product.status) {
      case ProductStatus.outOfStock:
        textColor = Colors.red.withAlpha(100);
        backgroundColor = theme.colorScheme.destructive;
        break;
      case ProductStatus.lowStock:
        textColor = Colors.yellow.withAlpha(100);
        backgroundColor = Colors.yellow[600];
        break;
      case ProductStatus.available:
        textColor = Colors.green.withAlpha(100);
        backgroundColor = Colors.green;
        break;
    }
    return Scaffold(
      appBar: AppBar(
          leading: ShadButton.ghost(
            child: Icon(LucideIcons.arrowLeft),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(widget.product.name),
          actions: [
            ShadButton(
              onPressed: () {},
              child: Text("Edit Product"),
              icon: Icon(LucideIcons.penLine),
            ),
          ]),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShadCard(
              child: Column(
                children: [
                  Flexible(
                    child: Container(
                      child: Center(
                        child: Icon(
                          LucideIcons.package2,
                          size: 24.w,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.product.name,
                              style:
                                  theme.textTheme.h1.copyWith(fontSize: 16.sp),
                            ),
                            ShadBadge(
                              backgroundColor: backgroundColor,
                              child: Text(
                                widget.product.status.name,
                                style: theme.textTheme.small
                                    .copyWith(color: textColor),
                              ),
                            )
                          ],
                        ),
                        Text('SKU: ${widget.product.sku!}'),
                        Text('Description'),
                        Text(widget.product.description!),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
