import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/core/utils/constants_enums.dart';
import 'package:shop_mate/core/utils/currency_formatter.dart';
import 'package:shop_mate/core/utils/helpers.dart';
import 'package:shop_mate/data/models/inventory/inventory_item_model.dart';
import 'package:shop_mate/data/models/inventory/inventory_model.dart';
import 'package:shop_mate/data/models/products/product_model.dart';
import 'package:shop_mate/providers/inventory_provider.dart';
import 'package:shop_mate/screens/inventory/register_product_screen.dart';
import 'package:shop_mate/screens/inventory/view_product_screen.dart'; // You'll need to create this
import 'package:shop_mate/screens/inventory/edit_product_screen.dart';
import 'package:shop_mate/screens/inventory/widgets/inventory_item_card.dart'; // You'll need to create this

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _sortBy = 'Name';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Rebuild when tab changes
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<InventoryProvider>(context, listen: false).reset();
      Provider.of<InventoryProvider>(context, listen: false).initStream();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showSortOptions() {
    final theme = ShadTheme.of(context);
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Sort By',
              style: theme.textTheme.h3,
            ),
            SizedBox(height: 16.h),
            ListTile(
              title: Text('Name (A-Z)'),
              trailing: _sortBy == 'Name' ? Icon(LucideIcons.check) : null,
              onTap: () {
                setState(() {
                  _sortBy = 'Name';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Price (Low to High)'),
              trailing: _sortBy == 'Price Low' ? Icon(LucideIcons.check) : null,
              onTap: () {
                setState(() {
                  _sortBy = 'Price Low';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Price (High to Low)'),
              trailing:
                  _sortBy == 'Price High' ? Icon(LucideIcons.check) : null,
              onTap: () {
                setState(() {
                  _sortBy = 'Price High';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Date Added (Newest)'),
              trailing: _sortBy == 'Date New' ? Icon(LucideIcons.check) : null,
              onTap: () {
                setState(() {
                  _sortBy = 'Date New';
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterOptions() {
    final theme = ShadTheme.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: EdgeInsets.all(16.w),
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Inventory',
              style: theme.textTheme.h3,
            ),
            SizedBox(height: 16.h),
            Text(
              'Categories',
              style: theme.textTheme.h4,
            ),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: ['All', 'Electronics', 'Clothing', 'Food', 'Beverages']
                  .map((category) => FilterChip(
                        label: Text(category),
                        selected: _selectedCategory == category,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = selected ? category : 'All';
                          });
                        },
                      ))
                  .toList(),
            ),
            SizedBox(height: 16.h),
            Text(
              'Status',
              style: theme.textTheme.h4,
            ),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: ProductStatus.values
                  .map((status) => FilterChip(
                        label: Text(status.name),
                        selected: false, // Track selected statuses
                        onSelected: (selected) {
                          // Implement filter logic
                        },
                      ))
                  .toList(),
            ),
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: ShadButton.outline(
                    onPressed: () {
                      // Reset filters
                      setState(() {
                        _selectedCategory = 'All';
                      });
                      Navigator.pop(context);
                    },
                    child: Text('Reset'),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: ShadButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<InventoryItem> _filterAndSortItems(List<InventoryItem> items) {
    // Filter by search query
    var filteredItems = items
        .where((item) =>
            item.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    // Filter by category
    if (_selectedCategory != 'All') {
      // Implement category filtering when you have categories
      // filteredItems = filteredItems.where((item) => item.category == _selectedCategory).toList();
    }

    // Sort
    switch (_sortBy) {
      case 'Name':
        filteredItems.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Price Low':
        filteredItems.sort((a, b) => a.salesPrice.compareTo(b.salesPrice));
        break;
      case 'Price High':
        filteredItems.sort((a, b) => b.salesPrice.compareTo(a.salesPrice));
        break;
      case 'Date New':
        // Implement if you have createdAt field
        // filteredItems.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }

    return filteredItems;
  }

  // Calculate grid cross axis count based on screen width
  int _getCrossAxisCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width > 1200) return 5; // Desktop large
    if (width > 900) return 4; // Desktop
    if (width > 600) return 3; // Tablet
    if (width > 400) return 2; // Mobile large
    return 1; // Mobile small
  }

  @override
  Widget build(BuildContext context) {
    final inventProv = Provider.of<InventoryProvider>(context);
    final theme = ShadTheme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              floating: true,
              pinned: true,
              title: Text(
                'Inventory',
                style: theme.textTheme.h2.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(LucideIcons.chartBar),
                  onPressed: () {
                    // Navigate to inventory analytics
                  },
                ),
                IconButton(
                  icon: Icon(LucideIcons.plus),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RegisterProductScreen(),
                    ));
                  },
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(isSmallScreen ? 150.h : 110.h),
                child: Column(
                  children: [
                    // Search Bar
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      child: ShadInput(
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        placeholder: Text('Search inventory...'),
                        leading: Icon(LucideIcons.search),
                        decoration: ShadDecoration(
                          border: ShadBorder(
                            radius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    // Filter and Sort Controls
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 4.h,
                      ),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minWidth: width(context, 0.3)),
                        child: isSmallScreen
                            ? Column(
                                children: [
                                  _buildFilterAndSortRow(theme),
                                  SizedBox(height: 8.h),
                                  _buildTabBar(theme),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                      child: _buildFilterAndSortRow(theme)),
                                  _buildTabBar(theme),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Inventory Items
            StreamBuilder<List<InventoryItem>>(
              stream: inventProv.inventoryStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError) {
                  return SliverFillRemaining(
                    child: _buildErrorWidget(theme),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return SliverFillRemaining(
                    child: _buildEmptyInventoryWidget(theme),
                  );
                }

                final filteredItems = _filterAndSortItems(snapshot.data!);

                if (filteredItems.isEmpty) {
                  return SliverFillRemaining(
                    child: _buildNoMatchesWidget(theme),
                  );
                }

                return SliverPadding(
                  padding: EdgeInsets.all(16.w),
                  sliver: _buildTabView(filteredItems),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => RegisterProductScreen(),
          ));
        },
        child: Icon(LucideIcons.plus),
      ),
    );
  }

  Widget _buildFilterAndSortRow(ShadThemeData theme) {
    return Row(
      children: [
        _buildFilterButton(theme),
        SizedBox(width: 8.w),
        _buildSortButton(theme),
      ],
    );
  }

  Widget _buildFilterButton(ShadThemeData theme) {
    return InkWell(
      onTap: _showFilterOptions,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 6.h,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.border,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.filter, size: 16),
            SizedBox(width: 4.w),
            Text('Filter'),
            if (_selectedCategory != 'All') ...[
              SizedBox(width: 4.w),
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '1',
                  style: TextStyle(
                    color: theme.colorScheme.primaryForeground,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSortButton(ShadThemeData theme) {
    return InkWell(
      onTap: _showSortOptions,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 6.h,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.border,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.arrowUpDown, size: 16),
            SizedBox(width: 4.w),
            Text('Sort: $_sortBy'),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar(ShadThemeData theme) {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      tabs: [
        Tab(text: 'Grid'),
        Tab(text: 'List'),
        Tab(text: 'Table'),
      ],
      labelColor: theme.colorScheme.primary,
      indicatorColor: theme.colorScheme.primary,
      unselectedLabelColor: theme.colorScheme.mutedForeground,
      indicatorSize: TabBarIndicatorSize.label,
    );
  }

  Widget _buildErrorWidget(ShadThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.circleAlert,
            size: 48,
            color: theme.colorScheme.destructive,
          ),
          SizedBox(height: 16.h),
          Text(
            'Error loading inventory',
            style: theme.textTheme.p.copyWith(
              color: theme.colorScheme.destructive,
            ),
          ),
          SizedBox(height: 8.h),
          ShadButton(
            onPressed: () {
              Provider.of<InventoryProvider>(context, listen: false).reset();
              Provider.of<InventoryProvider>(context, listen: false)
                  .initStream();
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyInventoryWidget(ShadThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.package,
            size: 64,
            color: theme.colorScheme.muted,
          ),
          SizedBox(height: 16.h),
          Text(
            'Your inventory is empty',
            style: theme.textTheme.p.copyWith(
              color: theme.colorScheme.muted,
            ),
          ),
          SizedBox(height: 16.h),
          ShadButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RegisterProductScreen(),
              ));
            },
            leading: Icon(LucideIcons.plus),
            child: Text('Add Your First Product'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoMatchesWidget(ShadThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.search,
            size: 64,
            color: theme.colorScheme.muted,
          ),
          SizedBox(height: 16.h),
          Text(
            'No items match your search',
            style: theme.textTheme.p,
          ),
          SizedBox(height: 8.h),
          Text(
            'Try adjusting your filters or search terms',
            style: theme.textTheme.small.copyWith(
              color: theme.colorScheme.muted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabView(List<InventoryItem> items) {
    final screenWidth = MediaQuery.of(context).size.width;

    switch (_tabController.index) {
      case 0: // Grid View
        return SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, index) => InventoryItemCard(item: items[index]),
            childCount: items.length,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _getCrossAxisCount(context),
            crossAxisSpacing: 8.w,
            mainAxisSpacing: 14.h,
            childAspectRatio: screenWidth > 600
                ? 0.6
                : 0.75, // Adjust aspect ratio for different screens
          ),
        );
      case 1: // List View
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Column(
              children: [
                ProductListTile(item: items[index]),
                Divider(),
              ],
            ),
            childCount: items.length,
          ),
        );
      case 2: // Table View
        return screenWidth < 600
            ? SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Column(
                    children: [
                      ResponsiveTableRow(item: items[index]),
                      Divider(),
                    ],
                  ),
                  childCount: items.length,
                ),
              )
            : SliverToBoxAdapter(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Price')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Quantity')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: items
                        .map((item) => DataRow(
                              cells: [
                                DataCell(Text(item.name)),
                                DataCell(
                                    Text(formatPrice(price: item.salesPrice))),
                                DataCell(StatusBadge(status: item.status)),
                                DataCell(Text('${item.quantity}')),
                                DataCell(Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(LucideIcons.eye),
                                      onPressed: () =>
                                          _viewProduct(context, item),
                                    ),
                                    IconButton(
                                      icon: Icon(LucideIcons.penLine),
                                      onPressed: () =>
                                          _editProduct(context, item),
                                    ),
                                  ],
                                )),
                              ],
                            ))
                        .toList(),
                  ),
                ),
              );
      default:
        return SliverToBoxAdapter(child: SizedBox.shrink());
    }
  }

  void _viewProduct(BuildContext context, InventoryItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ViewProductScreen(item: item),
      ),
    );
  }

  void _editProduct(BuildContext context, InventoryItem item) {
    // Navigate to edit screen when available
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => EditProductScreen(item: item),
    //   ),
    // );
  }
}

// Alternative for table view on small screens
class ResponsiveTableRow extends StatelessWidget {
  final InventoryItem item;

  const ResponsiveTableRow({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.name,
                  style: theme.textTheme.p.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              StatusBadge(status: item.status),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Price: ${formatPrice(price: item.salesPrice)}',
                style: theme.textTheme.small,
              ),
              Text(
                'Quantity: ${item.quantity}',
                style: theme.textTheme.small,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(LucideIcons.eye, size: 20),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ViewProductScreen(item: item),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(LucideIcons.penLine, size: 20),
                onPressed: () {
                  // Navigate to edit screen
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// class ProductCard extends StatefulWidget {
//   final InventoryItem item;

//   const ProductCard({
//     super.key,
//     required this.item,
//   });

//   @override
//   State<ProductCard> createState() => _ProductCardState();
// }

// class _ProductCardState extends State<ProductCard> {
//   final popoverController = ShadPopoverController();

//   @override
//   void dispose() {
//     popoverController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = ShadTheme.of(context);

//     return GestureDetector(
//       onTap: () {
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (context) => ViewProductScreen(item: widget.item),
//           ),
//         );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: theme.cardTheme.backgroundColor,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Stack(
//               children: [
//                 Container(
//                   height: width(context, 0.15),
//                   decoration: BoxDecoration(
//                     color: theme.colorScheme.mutedForeground.withOpacity(0.1),
//                     borderRadius: BorderRadius.vertical(
//                       top: Radius.circular(12),
//                     ),
//                     // image: item.imageUrl != null && item.imageUrl!.isNotEmpty
//                     //     ? DecorationImage(
//                     //         image: NetworkImage(item.imageUrl!),
//                     //         fit: BoxFit.cover,
//                     //       )
//                     //     : null,
//                   ),
//                   child: Center(
//                     child: Icon(
//                       LucideIcons.package,
//                       size: width(context, 0.07),
//                       color: theme.colorScheme.mutedForeground,
//                     ),
//                     // child: item.imageUrl == null || item.imageUrl!.isEmpty
//                     //     ? Center(
//                     //         child: Icon(
//                     //           LucideIcons.package,
//                     //           size: width(context, 0.07),
//                     //           color: Colors.grey,
//                     //         ),
//                     //       )
//                     //     : null,
//                   ),
//                 ),
//                 Positioned(
//                   top: 8,
//                   right: 8,
//                   child: ShadPopover(
//                     controller: popoverController,
//                     popover: (context) => SizedBox(
//                       width: 49.w,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           PopupMenuItem(
//                             child: Row(
//                               children: [
//                                 Icon(LucideIcons.eye, size: 16),
//                                 SizedBox(width: 8.w),
//                                 Text('View Details'),
//                               ],
//                             ),
//                             onTap: () {
//                               popoverController.toggle();
//                               Navigator.of(context).push(
//                                 MaterialPageRoute(
//                                   builder: (context) =>
//                                       ViewProductScreen(item: widget.item),
//                                 ),
//                               );
//                               // Add a delay to allow the menu to close
//                               // Future.delayed(Duration(milliseconds: 100), () {
//                               //   Navigator.of(context).push(
//                               //     MaterialPageRoute(
//                               //       builder: (context) =>
//                               //           ViewProductScreen(item: widget.item),
//                               //     ),
//                               //   );
//                               // });
//                             },
//                           ),
//                           PopupMenuItem(
//                             child: Row(
//                               children: [
//                                 Icon(LucideIcons.penLine, size: 16),
//                                 SizedBox(width: 8.w),
//                                 Text('Edit Product'),
//                               ],
//                             ),
//                             onTap: () {
//                               Future.delayed(Duration(milliseconds: 100), () {
//                                 // Navigator.of(context).push(
//                                 //   MaterialPageRoute(
//                                 //     builder: (context) => EditProductScreen(item: item),
//                                 //   ),
//                                 // );
//                               });
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                     child: Container(
//                       padding: EdgeInsets.all(4),
//                       decoration: BoxDecoration(
//                         color: theme.colorScheme.background.withOpacity(0.8),
//                         shape: BoxShape.circle,
//                       ),
//                       child: ShadButton.ghost(
//                         padding: EdgeInsets.all(8.0),
//                         onPressed: popoverController.toggle,
//                         child: Icon(
//                           LucideIcons.ellipsisVertical,
//                           size: 5.w,
//                         ),
//                       ),
//                     ),
//                     // ],
//                   ),
//                 ),
//                 Positioned(
//                   top: 8,
//                   left: 8,
//                   child: StatusBadge(status: widget.item.status),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     widget.item.name,
//                     style: theme.textTheme.p.copyWith(
//                       fontWeight: FontWeight.bold,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   SizedBox(height: 4.h),
//                   Text(
//                     // '₦${widget.item.salesPrice.toStringAsFixed(2)}',
//                     formatPrice(price: widget.item.salesPrice),
//                     style: theme.textTheme.p.copyWith(
//                       color: theme.colorScheme.primary,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 4.h),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(
//                             LucideIcons.package,
//                             size: 14,
//                             color: theme.colorScheme.mutedForeground,
//                           ),
//                           SizedBox(width: 4.w),
//                           Text(
//                             '${widget.item.quantity} in stock',
//                             style: theme.textTheme.small.copyWith(
//                               color: theme.colorScheme.mutedForeground,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


class ProductListTile extends StatelessWidget {
  final InventoryItem item;

  const ProductListTile({
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
            builder: (context) => ViewProductScreen(item: item),
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
                        '₦${item.salesPrice.toStringAsFixed(2)}',
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
                                  ViewProductScreen(item: item),
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

class StatusBadge extends StatelessWidget {
  // final ProductStatus status;
  final InventoryStatus status;

  const StatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    Color backgroundColor;
    Color textColor;

    switch (status) {
      // case ProductStatus.active:
      case InventoryStatus.inStock:
        backgroundColor = Colors.green.withOpacity(0.2);
        textColor = Colors.green;
        break;
      case InventoryStatus.outOfStock:
        backgroundColor = Colors.red.withOpacity(0.2);
        textColor = Colors.red;
        break;
      case InventoryStatus.lowStock:
        backgroundColor = Colors.orange.withOpacity(0.2);
        textColor = Colors.orange;
        break;
      default:
        backgroundColor = theme.colorScheme.muted.withOpacity(0.2);
        textColor = theme.colorScheme.muted;
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 15.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          status.name,
          style: theme.textTheme.small.copyWith(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 3.5.w,
          ),
        ),
      ),
    );
  }
}
