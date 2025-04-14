import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shop_mate/providers/product_provider.dart';
import 'package:provider/provider.dart';

class ProductSearchBar extends StatefulWidget {
  final TextEditingController controller;

  const ProductSearchBar({
    super.key,
    required this.controller,
  });

  @override
  State<ProductSearchBar> createState() => _ProductSearchBarState();
}

class _ProductSearchBarState extends State<ProductSearchBar> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<ProductProvider>().searchProducts(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: 'Search products...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              widget.controller.clear();
              context.read<ProductProvider>().clearSearch();
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onChanged: _onSearchChanged,
      ),
    );
  }
}
