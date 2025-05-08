import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/core/utils/currency_formatter.dart';
import 'package:shop_mate/data/models/inventory/inventory_item_model.dart';
import 'package:shop_mate/data/models/inventory/inventory_model.dart';
import 'package:shop_mate/screens/inventory/view_inventory_item_screen.dart';
import 'package:shop_mate/screens/products/view_product_screen.dart';

class InventoryItemCard extends StatefulWidget {
  final InventoryItem item;

  const InventoryItemCard({
    super.key,
    required this.item,
  });

  @override
  State<InventoryItemCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<InventoryItemCard> {
  final popoverController = ShadPopoverController();

  @override
  void dispose() {
    popoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return ShadCard(
      padding: EdgeInsets.all(0),
      width: double.infinity,
      // height: isSmallScreen ? null : 500.h,
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image/Icon Section
          Flexible(
            flex: 3,
            child: Stack(
              children: [
                Container(
                  height: isSmallScreen ? 120 : 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.muted.withOpacity(0.2),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(6),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      LucideIcons.package,
                      size: isSmallScreen ? 24 : 32,
                      color: theme.colorScheme.mutedForeground,
                    ),
                  ),
                ),
                // Status Badge
                Positioned(
                  top: 8,
                  left: 8,
                  child: ShadBadge(
                    backgroundColor:
                        widget.item.status == InventoryStatus.outOfStock
                            ? Colors.red.withAlpha(100)
                            : widget.item.status == InventoryStatus.lowStock
                                ? Colors.yellow.withAlpha(100)
                                : Colors.green.withAlpha(100),
                    child: Text(
                      widget.item.status.name,
                      style: TextStyle(
                        color: widget.item.status == InventoryStatus.outOfStock
                            ? theme.colorScheme.destructive
                            : widget.item.status == InventoryStatus.lowStock
                                ? Colors.yellow[600]
                                : Colors.green,
                        // color: theme.colorScheme.muted,
                        // backgroundColor:
                        //     widget.item.status == InventoryStatus.outOfStock
                        //         ? theme.colorScheme.destructive
                        //         : widget.item.status == InventoryStatus.lowStock
                        //             ? Colors.yellow
                        //             : Colors.green,
                      ),
                    ),
                  ),
                  // child: StatusBadge(status: widget.item.status),
                ),
                // Options Menu
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
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ViewInventoryItemScreen(
                                      item: widget.item),
                                ),
                              );
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
                        ],
                      ),
                    ),
                    child: ShadButton.ghost(
                      onPressed: () {
                        popoverController.toggle();
                      },
                      size: ShadButtonSize.sm,
                      padding: EdgeInsets.zero,
                      child: Icon(
                        LucideIcons.ellipsisVertical,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Product Info Section
          Flexible(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 8.h),
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  ShadTooltip(
                    // text: widget.item.name,
                    builder: (context) {
                      return Text(
                        widget.item.name,
                        style: theme.textTheme.small.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                    child: Text(
                      widget.item.name,
                      style: theme.textTheme.small.copyWith(
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Price
                  Text(
                    formatPrice(price: widget.item.salesPrice),
                    style: theme.textTheme.large.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.fade,
                    ),
                    maxLines: 1,
                  ),
                  SizedBox(height: 6.h),
                  // Stock Info
                  ShadBadge.secondary(
                    
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.package,
                          size: 14,
                          color: theme.colorScheme.mutedForeground,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          '${widget.item.quantity} in stock',
                          style: theme.textTheme.small.copyWith(
                            color: theme.colorScheme.mutedForeground,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
