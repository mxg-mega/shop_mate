import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/providers/product_provider.dart';
import 'package:shop_mate/screens/products/product_registeration_screen.dart';
import 'package:shop_mate/widgets/layout/responsive_product_grid.dart';
import 'package:shop_mate/widgets/search/product_search_bar.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // final productProvider = context.read<ProductProvider>();
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    productProvider.fetchInitialProducts();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<ProductProvider>().loadMoreProducts();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Products',
          style: theme.textTheme.h2.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          ShadButton(
            onPressed: () {
              // Navigate to add product screen
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RegisterProductScreen(),
              ));
            },
            child: Row(
              children: [
                const Icon(Icons.add),
                SizedBox(width: 2.w),
                const Text('Add Product'),
              ],
            ),
          ),
        ],
        actionsPadding: EdgeInsets.only(left: 5.w),
      ),
      body: Column(
        children: [
          ProductSearchBar(controller: _searchController),
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, provider, child) {
                if (provider.products.isEmpty && !provider.isLoadingMore) {
                  return const Center(child: Text('No products found'));
                }

                return RefreshIndicator(
                  onRefresh: () => provider.fetchInitialProducts(),
                  child: ResponsiveProductGrid(
                    controller: _scrollController,
                    products: provider.products,
                    isLoading: provider.isLoadingMore,
                    hasMore: provider.hasMoreProducts,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: ShadTooltip(
        builder: (context) => const Text('Add Product'),
        child: FloatingActionButton(
          onPressed: () {
            // Navigate to add product screen
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => RegisterProductScreen(),
            ));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
