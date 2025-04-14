import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_mate/data/models/products/product_model.dart';
import 'package:shop_mate/widgets/product/product_card.dart';

class ResponsiveProductGrid extends StatelessWidget {
  final ScrollController controller;
  final List<Product> products;
  final bool isLoading;
  final bool hasMore;

  const ResponsiveProductGrid({
    super.key,
    required this.controller,
    required this.products,
    required this.isLoading,
    required this.hasMore,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Adjust layout based on screen width
        final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
        final childAspectRatio = constraints.maxWidth > 600 ? 0.8 : 0.9;

        return GridView.builder(
          controller: controller,
          padding: EdgeInsets.all(8.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: products.length + (hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= products.length) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0.w),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return Padding(
              padding: EdgeInsets.all(8.0.w),
              child: ProductCard(product: products[index]),
            );
          },
        );
      },
    );
  }
}
