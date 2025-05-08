import 'dart:async';
import 'widgets/location_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/core/utils/constants.dart';
import 'package:shop_mate/core/utils/constants_enums.dart';
import 'package:shop_mate/core/utils/currency_formatter.dart';
import 'package:shop_mate/data/models/inventory/inventory_item_model.dart' show InventoryItem;
import 'package:shop_mate/data/models/products/product_model.dart';
import 'package:shop_mate/providers/inventory_provider.dart';
import 'package:shop_mate/providers/product_provider.dart';
import 'package:shop_mate/services/business_service.dart';

class InventoryItemEditScreen extends StatefulWidget {
  const InventoryItemEditScreen({super.key, required this.inventoryItem});

  final InventoryItem inventoryItem;

  @override
  State<InventoryItemEditScreen> createState() =>
      _InventoryItemEditScreenState();
}

class _InventoryItemEditScreenState extends State<InventoryItemEditScreen> {
  final formKey = GlobalKey<ShadFormState>();

  Product? _product;
  List<Product> _products = [];
  String? _location;
  double? _quantity;

  final TextEditingController _quantityController = TextEditingController();
  Timer? _debounce;
  bool hasExpiryDate = false;
  DateTime? expiryDate;

  @override
  void dispose() {
    _debounce?.cancel();
    _quantityController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<ProductProvider>().searchProducts(query);
    });
  }

  @override
  void initState() {
    super.initState();

    // Initialize form fields with existing inventory item data
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final productProv = context.read<ProductProvider>();

      // Fetch product if not already loaded
      Product? product = productProv.products
          .firstWhere((p) => p.id == widget.inventoryItem.productId,
              orElse: () => Product(
                    id: '',
                    name: '',
                    category: ProductCategory.none,
                    baseUnit: '',
                    businessId: '',
                    costPrice: 0.0,
                    salesPrice: 0.0,
                    stockQuantity: 0.0,
                    isActive: false,
                    sku: '',
                  ));

      if (product.id == '') {
        product =
            await productProv.fetchProduct(widget.inventoryItem.productId);
      }

      setState(() {
        _product = product;
        _location = widget.inventoryItem.location;
        _quantity = widget.inventoryItem.quantity;
        _quantityController.text = _quantity?.toString() ?? '';
        hasExpiryDate = widget.inventoryItem.expiryDate != null;
        expiryDate = widget.inventoryItem.expiryDate;
      });
    });

    // Fetch initial products if needed
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<ProductProvider>().fetchInitialProducts(limit: 100);
      setState(() {
        _products = context.read<ProductProvider>().products;
      });
    });
  }

  Widget _buildProductOption(Product product) {
    final theme = ShadTheme.of(context);
    return ShadOption(
      value: product,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: theme.textTheme.h4.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(product.description ?? ''),
            Perimeter(height: 1),
            Text(
              product.category.name,
              style: theme.textTheme.small
                  .copyWith(color: theme.colorScheme.mutedForeground),
            ),
            Perimeter(height: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Stock: ${product.stockQuantity}',
                  style: theme.textTheme.small.copyWith(
                    color: theme.colorScheme.mutedForeground,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  formatPrice(price: product.salesPrice),
                  style: theme.textTheme.small.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Text _buildHeaders(String text) {
    final theme = ShadTheme.of(context);
    return Text(
      text,
      style: theme.textTheme.h3.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inventoryProv = Provider.of<InventoryProvider>(context);
    final productProv = Provider.of<ProductProvider>(context);
    final biz = BusinessService.instance.currentBusiness!;
    final theme = ShadTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Inventory Item',
          style: theme.textTheme.h2.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          ShadButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final updatedItem = _product!.createInventoryItem(
                  initialStock: _quantity!,
                  inventoryItemId: widget.inventoryItem.id,
                  location: _location,
                  expiryDate: hasExpiryDate ? expiryDate : null,
                );
                // await inventoryProv.updateInventoryItem(updatedItem);
                await inventoryProv.updateItem(updatedItem);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Update Item'),
          ),
        ],
        actionsPadding: EdgeInsets.only(left: 5.w),
        leading: ShadButton.ghost(
          child: Icon(LucideIcons.arrowLeft),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: productProv.isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(
                strokeWidth: 2,
                backgroundColor: Colors.white,
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(8.w),
              child: ShadForm(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaders('Select Product'),
                    Perimeter(height: 2),
                    ShadSelectFormField<Product>.withSearch(
                      initialValue: _product,
                      itemCount: productProv.products.length,
                      placeholder: Text('Select a Product'),
                      optionsBuilder: (context, index) =>
                          _buildProductOption(productProv.products[index]),
                      selectedOptionBuilder: (context, product) {
                        return product == null
                            ? Text('Select the Product')
                            : _buildProductOption(product);
                      },
                      onChanged: (product) {
                        setState(() {
                          _product = product;
                        });
                      },
                      onSearchChanged: (searchParam) =>
                          _onSearchChanged(searchParam),
                    ),
                    Perimeter(height: 5),
                    _buildHeaders('Inventory Locations'),
                    Perimeter(height: 2),
                    Text(
                      'Select locations and specify quantities for this inventory item.',
                      style: theme.textTheme.small.copyWith(
                        color: theme.colorScheme.mutedForeground,
                      ),
                    ),
                    Perimeter(height: .5),
                    LocationSelectorWidget(
                      locations: biz.locations!,
                      selectedLocation: _location,
                      onLocationChanged: (location) {
                        setState(() {
                          _location = location;
                        });
                      },
                      quantityController: _quantityController,
                      onQuantityChanged: (value) {
                        setState(() {
                          _quantity = double.tryParse(value);
                        });
                      },
                      productBaseUnit: _product?.baseUnit,
                    ),
                    Perimeter(height: .5),
                    ShadButton(
                      enabled: false,
                      onPressed: () {
                        // TODO: Implement Add location later on
                      },
                      child: const Text('Add Location'),
                    ),
                    Perimeter(height: .4),
                    Text(
                      'Note: You can add multiple locations and specify quantities for each location.'
                      ' Currently you have to go to settings to add a location.',
                      style: theme.textTheme.small.copyWith(
                        color: theme.colorScheme.mutedForeground,
                        fontSize: 5.sp,
                      ),
                    ),
                    Perimeter(height: 5),
                    _buildHeaders('Additional Information'),
                    Perimeter(height: 1),
                    _buildExpiryDateWidget(),
                    Perimeter(height: 5),
                  ],
                ),
              ),
            ),
    );
  }

  Column _buildExpiryDateWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShadDatePickerFormField(
          enabled: hasExpiryDate,
          label: const Text('Expiry Date *'),
          onChanged: (date) {
            setState(() {
              expiryDate = date;
            });
          },
          validator: (v) {
            if (v == null && hasExpiryDate) {
              return 'Please insert a valid expiry date please';
            }
            return null;
          },
          initialValue: expiryDate,
        ),
        ShadCheckboxFormField(
          initialValue: hasExpiryDate,
          id: 'expiry-date',
          inputLabel: Text(
            'Has Expiry Date',
          ),
          onChanged: (value) {
            setState(() {
              hasExpiryDate = value;
            });
          },
        ),
      ],
    );
  }
}
