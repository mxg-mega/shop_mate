import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/core/utils/constants.dart';
import 'package:shop_mate/data/models/products/product_model.dart';
import 'package:shop_mate/data/models/products/product_unit.dart';
import 'package:shop_mate/providers/product_provider.dart';
import 'package:shop_mate/providers/inventory_provider.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<ShadFormState>();

  late TextEditingController _nameController;
  late TextEditingController _costPriceController;
  late TextEditingController _salesPriceController;
  late TextEditingController _descriptionController;
  late TextEditingController _quantityController;

  ProductCategory? _selectedCategory;
  List<ProductUnit>? productUnits = [];
  DateTime? expiryDate;
  bool hasExpiryDate = true;

  double calculatedQuantity = 0.0;

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    _nameController = TextEditingController(text: product.name);
    _costPriceController = TextEditingController(text: product.costPrice.toString());
    _salesPriceController = TextEditingController(text: product.salesPrice.toString());
    _descriptionController = TextEditingController(text: product.description ?? '');
    _quantityController = TextEditingController(text: '0'); // Will be updated with calculated quantity
    _selectedCategory = product.category;
    productUnits = product.productUnits.map((unit) => unit.copyWith()).toList();
    expiryDate = product.expiryDate;
    hasExpiryDate = product.expiryDate != null;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateQuantity();
    });
  }

  void _calculateQuantity() {
    final inventoryProvider = Provider.of<InventoryProvider>(context, listen: false);
    final items = inventoryProvider.inventoryItems.where((item) => item.productId == widget.product.id);
    final totalQuantity = items.fold<double>(0, (sum, item) => sum + item.quantity);
    setState(() {
      calculatedQuantity = totalQuantity;
      _quantityController.text = calculatedQuantity.toStringAsFixed(2);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _costPriceController.dispose();
    _salesPriceController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final theme = ShadTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: ShadButton.ghost(
          child: Icon(LucideIcons.arrowLeft),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Edit Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ShadForm(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Basic Information', style: theme.textTheme.h3),
                SizedBox(height: 16),
                ShadInputFormField(
                  controller: _nameController,
                  label: const Text('Product Name *'),
                  placeholder: const Text('Product name'),
                  decoration: const ShadDecoration(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                ShadSelectFormField<ProductCategory>(
                  label: const Text('Product Category *'),
                  shrinkWrap: true,
                  anchor: ShadAnchor(childAlignment: Alignment.bottomLeft),
                  onChanged: (category) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  initialValue: _selectedCategory ?? ProductCategory.none,
                  itemCount: ProductCategory.values.length,
                  options: ProductCategory.values
                      .map((category) => ShadOption(value: category, child: Text(category.name)))
                      .toList(),
                  selectedOptionBuilder: (context, category) =>
                      category == ProductCategory.none
                          ? const Text('Please Select a Product Category')
                          : Text(category.name),
                ),
                SizedBox(height: 16),
                ShadInputFormField(
                  maxLines: 5,
                  controller: _descriptionController,
                  label: const Text('Description'),
                  placeholder: const Text('Product Description...'),
                ),
                SizedBox(height: 40),
                Text('Pricing', style: theme.textTheme.h3),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ShadInputFormField(
                        controller: _costPriceController,
                        label: const Text('Cost Price *'),
                        placeholder: const Text('Price Bought at'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            final parsedCost = double.tryParse(value);
                            if (parsedCost != null) {
                              for (var i = 0; i < productUnits!.length; i++) {
                                if (productUnits![i].isBaseUnit) {
                                  productUnits![i] = productUnits![i].copyWith(costPrice: parsedCost);
                                }
                              }
                            }
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter cost price';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ShadInputFormField(
                        controller: _salesPriceController,
                        label: const Text('Sales Price *'),
                        placeholder: const Text('Price Sold at'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            final parsedPrice = double.tryParse(value);
                            if (parsedPrice != null) {
                              for (var i = 0; i < productUnits!.length; i++) {
                                if (productUnits![i].isBaseUnit) {
                                  productUnits![i] = productUnits![i].copyWith(price: parsedPrice);
                                }
                              }
                            }
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter sales price';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ShadInputFormField(
                  controller: _quantityController,
                  label: const Text('Quantity'),
                  enableInteractiveSelection: false,
                  enabled: false,
                  decoration: const ShadDecoration(),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 40),
                ShadButton(
                  onPressed: provider.isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            final updatedProduct = Product(
                              id: widget.product.id,
                              name: _nameController.text,
                              costPrice: double.tryParse(_costPriceController.text) ?? 0.0,
                              salesPrice: double.tryParse(_salesPriceController.text) ?? 0.0,
                              stockQuantity: calculatedQuantity,
                              category: _selectedCategory ?? ProductCategory.others,
                              sku: widget.product.sku,
                              isActive: widget.product.isActive,
                              productUnits: productUnits,
                              description: _descriptionController.text,
                              expiryDate: expiryDate,
                              baseUnit: widget.product.baseUnit,
                              businessId: widget.product.businessId,
                              createdAt: widget.product.createdAt,
                              updatedAt: DateTime.now(),
                              imageUrl: widget.product.imageUrl,
                            );
                            await provider.updateProduct(widget.product.id, updatedProduct);
                            Navigator.of(context).pop();
                          }
                        },
                  child: provider.isLoading
                      ? CircularProgressIndicator(color: theme.colorScheme.secondary)
                      : const Text('Update Product'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
