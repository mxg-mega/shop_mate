import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/core/utils/currency_formatter.dart';
import 'package:shop_mate/data/models/products/product_model.dart';
import 'package:shop_mate/screens/inventory/inventory_item_registration_screen.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final popoverController = ShadPopoverController();
  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return ShadCard(
      // elevation: 2,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(8),
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                  // image: DecorationImage(
                  //   image: NetworkImage(product.imageUrl!),
                  //   fit: BoxFit.cover,
                  //   onError: (exception, stackTrace) => Center(
                  //     child: Icon(LucideIcons.package,
                  //         size: 24, color: theme.colorScheme.mutedForeground),
                  //   ),
                  // ),
                ),
                child: widget.product.imageUrl! == null
                    ? Icon(LucideIcons.package,
                        size: 24.w, color: theme.colorScheme.mutedForeground)
                    : Image.network(
                        widget.product.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Icon(LucideIcons.package,
                              size: 24.w,
                              color: theme.colorScheme.mutedForeground),
                        ),
                      ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: ShadPopover(
                  controller: popoverController,
                  popover: (context) => SizedBox(
                    width: 90.w,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: const Text('View Details'),
                          leading: Icon(LucideIcons.eye),
                          onTap: () {
                            popoverController.toggle();
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (context) => ViewInventoryItemScreen(
                            //         item: widget.item),
                            //   ),
                            // );
                          },
                        ),
                        ListTile(
                          leading: Icon(LucideIcons.penLine, size: 16),
                          title: const Text('Edit Product'),
                          onTap: () {
                            popoverController.toggle();
                            // Handle edit action
                          },
                        ),
                        ListTile(
                          leading: Icon(LucideIcons.plus, size: 16),
                          title: const Text('Add Inventory Item'),
                          onTap: () {
                            popoverController.toggle();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    InventoryItemRegistrationScreen(
                                  productId: widget.product.id,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  child: ShadButton.ghost(
                    onPressed: () {
                      popoverController.toggle();
                    },
                    size: ShadButtonSize.regular,
                    padding: EdgeInsets.zero,
                    child: Icon(
                      LucideIcons.ellipsisVertical,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ]),
          ),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  // '\$${product.salesPrice.toStringAsFixed(2)}',
                  formatPrice(price: widget.product.salesPrice),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
