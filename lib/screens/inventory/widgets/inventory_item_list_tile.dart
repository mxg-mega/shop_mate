import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/core/utils/currency_formatter.dart';
import 'package:shop_mate/data/models/inventory/inventory_item_model.dart';
import 'package:shop_mate/screens/inventory/inventory_screen.dart';
import 'package:shop_mate/screens/inventory/view_inventory_item_screen.dart';

class InventoryItemListTile extends StatelessWidget {
  final InventoryItem item;

  const InventoryItemListTile({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ViewInventoryItemScreen(item: item),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                // image: item.imageUrl != null && item.imageUrl!.isNotEmpty
                //     ? DecorationImage(
                //         image: NetworkImage(item.imageUrl!),
                //         fit: BoxFit.cover,
                //       )
                //     : null,
              ),
              // child: item.imageUrl == null || item.imageUrl!.isEmpty
              //     ? Center(
              //         child: Icon(
              //           LucideIcons.package,
              //           size: 24,
              //           color: Colors.grey,
              //         ),
              //       )
              //     : null,
              child: Center(
                child: Icon(
                  LucideIcons.package,
                  size: 24,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: theme.textTheme.p.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Text(
                        // '₦${item.salesPrice.toStringAsFixed(2)}',
                        formatPrice(price: item.salesPrice),
                        style: theme.textTheme.small.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      StatusBadge(status: item.status),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              '${item.quantity} in stock',
              style: theme.textTheme.small.copyWith(
                color: theme.colorScheme.muted,
              ),
            ),
            SizedBox(width: 8.w),
            IconButton(
              icon: Icon(LucideIcons.ellipsisVertical, size: 16),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(LucideIcons.eye),
                        title: Text('View Details'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  ViewInventoryItemScreen(item: item),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(LucideIcons.penLine),
                        title: Text('Edit Product'),
                        onTap: () {
                          Navigator.pop(context);
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) => EditProductScreen(item: item),
                          //   ),
                          // );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
