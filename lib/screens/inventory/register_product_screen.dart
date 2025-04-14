import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/data/datasource/local/business_storage.dart';
import 'package:shop_mate/data/datasource/repositories/inventory_repository.dart';
import 'package:shop_mate/data/models/inventory/inventory_item_model.dart';
import 'package:shop_mate/data/models/products/product_model.dart';
import 'package:shop_mate/data/models/products/product_unit.dart';
import 'package:shop_mate/features/responsive_design/layouts/responsive_layout.dart';
import 'package:shop_mate/providers/authentication_provider.dart';
import 'package:shop_mate/providers/inventory_provider.dart';
import 'package:shop_mate/screens/inventory/product_unit_manager.dart';
import 'package:uuid/uuid.dart';

import '../../core/utils/constants_enums.dart';

class RegisterProductScreen extends StatefulWidget {
  const RegisterProductScreen({super.key});

  @override
  State<RegisterProductScreen> createState() => _RegisterProductScreenState();
}

class _RegisterProductScreenState extends State<RegisterProductScreen> {
  final _formKey = GlobalKey<ShadFormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _costPriceController = TextEditingController();
  final TextEditingController _salesPriceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _skuController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool hasExpiryDate = true;

  ProductCategory? _selectedCategory;
  List<ProductUnit> productUnits =
      Product.defaultProductUnits.map((unit) => unit.copyWith()).toList();
  DateTime? expiryDate;

  @override
  void initState() {
    super.initState();
    context
        .read<AuthenticationProvider>()
        .currentBusiness!
        .businessSettings!
        .defaultUnitSystem
        .toString();
  }

  List<Widget> _rowOfCategoryAndExpiry(bool isRow) {
    return [
      ShadSelectFormField<ProductCategory>(
        label: const Text('Product Category *'),
        shrinkWrap: true,
        anchor: ShadAnchor(childAlignment: Alignment.bottomLeft),
        onChanged: (category) {
          setState(() {
            _selectedCategory = category;
          });
        },
        initialValue: ProductCategory.none,
        itemCount: ProductCategory.values.length,
        options: ProductCategory.values
            .map((category) =>
                ShadOption(value: category, child: Text(category.name)))
            .toList(),
        selectedOptionBuilder: (context, category) =>
            category == ProductCategory.none
                ? const Text('Please Select a Product Category')
                : Text(category.name),
      ),
      isRow ? Perimeter(width: 3) : Perimeter(height: 2),
      Column(
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
              }),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InventoryProvider>(context);
    final authProv = Provider.of<AuthenticationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ShadForm(
            key: _formKey,
            child: Column(
              children: [
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
                Perimeter(height: 2),
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
                              for (var i = 0; i < productUnits.length; i++) {
                                if (productUnits[i].isBaseUnit) {
                                  productUnits[i] = productUnits[i]
                                      .copyWith(costPrice: parsedCost);
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
                    Perimeter(width: 2),
                    Expanded(
                      child: ShadInputFormField(
                        controller: _salesPriceController,
                        label: const Text('Sales Price *'),
                        placeholder: const Text('Price Sold at'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            final parsedCost = double.tryParse(value);
                            if (parsedCost != null) {
                              for (var i = 0; i < productUnits.length; i++) {
                                if (productUnits[i].isBaseUnit) {
                                  productUnits[i] = productUnits[i]
                                      .copyWith(price: parsedCost);
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
                Perimeter(height: 2),
                Row(
                  children: [
                    Expanded(
                      child: ShadInputFormField(
                        controller: _quantityController,
                        label: const Text('Quantity *'),
                        enableInteractiveSelection: true,
                        decoration: const ShadDecoration(),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter quantity';
                          }
                          return null;
                        },
                      ),
                    ),
                    Perimeter(width: 2),
                    Expanded(
                      child: ShadInputFormField(
                        controller: _locationController,
                        label: const Text('Location'),
                        placeholder: const Text('e.g Store, Warehouse etc.'),
                      ),
                    ),
                  ],
                ),
                Perimeter(height: 2),
                /* Disable the SKU field
                * TODO: this will be a widget that to a scanner to scan the barcode
                * when scanned, the barcode will be stored,
                * and the barcode will be displayed in the text field
                * and the barcode will be disabled
                * in the future we can make a look up table to check if the barcode is valid
                * and what information we can fetch using that code from public databases.
                * this feature can even serve as a shortcut for product registration.
                * making it easier for users to register products by just scanning the barcode.
                */
                ShadInputFormField(
                  controller: _skuController,
                  label: const Text('SKU/Barcode'),
                  placeholder: Text('This is Temporarily Disabled'),
                  enabled: false,
                ),
                Perimeter(height: 2),
                ShadInputFormField(
                  controller: _descriptionController,
                  label: Text('Description'),
                  placeholder: Text('Product Description...'),
                ),
                Perimeter(height: 2),
                ProductUnitManager(
                    costPrice:
                        double.tryParse(_costPriceController.text) ?? 0.0,
                    salesPrice:
                        double.tryParse(_salesPriceController.text) ?? 0.0,
                    units: productUnits,
                    onUnitsChanged: (units) {
                      setState(() {
                        productUnits = units;
                      });
                    }),
                Perimeter(height: 2),
                if (ResponsiveLayout.isMobile(context))
                  Column(
                    children: _rowOfCategoryAndExpiry(false),
                  )
                else
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _rowOfCategoryAndExpiry(true),
                  ),
                Perimeter(height: 5),
                ShadButton(
                  onPressed: provider.isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            final baseUnit = productUnits
                                .firstWhere((unit) => unit.isBaseUnit);
                            if (productUnits
                                    .where((unit) => unit.isBaseUnit)
                                    .length >
                                1) {
                              // Show an error dialog or a snackbar.
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Only one base unit is allowed.')),
                              );
                              return;
                            } else if (baseUnit.costPrice !=
                                    double.parse(_costPriceController.text) &&
                                baseUnit.price !=
                                    double.parse(_salesPriceController.text)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Please Edit your baseUnit pricing')),
                              );
                              // return;
                            }

                            final quantity =
                                int.parse(_quantityController.text);

                            final status =
                                InventoryItem.calculateStatus(quantity);

                            final newProduct = Product(
                              baseUnit: productUnits
                                  .firstWhere((unit) => unit.isBaseUnit)
                                  .unit
                                  .name,
                              businessId: authProv.currentBusiness!.id,
                                  // BusinessStorage.getBusinessProfile()!.id,
                              name: _nameController.text,
                              id: const Uuid().v4(),
                              costPrice:
                                  double.parse(_costPriceController.text),
                              salesPrice:
                                  double.parse(_salesPriceController.text),
                              stockQuantity:
                                  double.parse(_quantityController.text),
                              category:
                                  _selectedCategory ?? ProductCategory.others,
                              sku: Product.generateSKU(_nameController.text),
                              isActive: true,
                              productUnits: productUnits,
                              expiryDate: expiryDate,
                              description: _descriptionController.text,
                              imageUrl: '',
                            );
                            print(newProduct.toJson());
                            final newItem2 = newProduct.createInventoryItem(
                                location: _locationController.text,
                                initialStock:
                                    double.parse(_quantityController.text),
                                inventoryItemId: InventoryRepository()
                                    .getCollection()
                                    .doc()
                                    .id);

                            // // Set the Product
                            // newItem2.product = newProduct;

                            await provider.saveProduct(newProduct);
                            await provider.createInventoryItem(newItem2);
                            // provider.addInventory(newItem2);
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Failed to validate registration')),
                            );
                            return;
                          }
                        },
                  child: provider.isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Register Product'),
                ),
                // Consumer<InventoryProvider>(
                //   builder: (context, provider, child) {
                //     return ShadButton(
                //       onPressed: provider.isLoading
                //           ? null
                //           : () async {
                //         if (_formKey.currentState!.validate()) {
                //           final baseUnit = _product_units
                //               .firstWhere((unit) => unit.isBaseUnit);
                //           if (_product_units
                //               .where((unit) => unit.isBaseUnit)
                //               .length >
                //               1) {
                //             // Show an error dialog or a snackbar.
                //             ScaffoldMessenger.of(context).showSnackBar(
                //               const SnackBar(
                //                   content: Text(
                //                       'Only one base unit is allowed.')),
                //             );
                //             return;
                //           } else if (baseUnit.costPrice ==
                //               double.parse(
                //                   _costPriceController.text) &&
                //               baseUnit.price ==
                //                   double.parse(
                //                       _salesPriceController.text)) {
                //             ScaffoldMessenger.of(context).showSnackBar(
                //               const SnackBar(
                //                   content: Text(
                //                       'Please Edit your baseUnit pricing')),
                //             );
                //             // return;
                //           }
                //
                //           final quantity =
                //           int.parse(_quantityController.text);
                //
                //           final status =
                //           InventoryItem.calculateStatus(quantity);
                //
                //           final newProduct = Product(
                //             baseUnit: _baseUnitPopController!.name,
                //             businessId:
                //             BusinessStorage.getBusinessProfile()!.id,
                //             name: _nameController.text,
                //             id: const Uuid().v4(),
                //             costPrice:
                //             double.parse(_costPriceController.text),
                //             salesPrice:
                //             double.parse(_salesPriceController.text),
                //             stockQuantity:
                //             double.parse(_quantityController.text),
                //             category: _selectedCategory ??
                //                 ProductCategory.others,
                //             sku:
                //             Product.generateSKU(_nameController.text),
                //             isActive: true,
                //             productUnits: _product_units,
                //           );
                //           final newItem2 = newProduct.createInventoryItem(
                //               location: '',
                //               initialStock:
                //               double.parse(_quantityController.text),
                //               inventoryItemId: InventoryRepository()
                //                   .getCollection()
                //                   .doc()
                //                   .id);
                //
                //           // // Set the Product
                //           // newItem2.product = newProduct;
                //
                //           provider.addInventory(newItem2);
                //           await provider.createInventoryItem(newItem2);
                //           await provider.saveProduct(newProduct);
                //           Navigator.pop(context);
                //         } else {
                //           ScaffoldMessenger.of(context).showSnackBar(
                //             const SnackBar(
                //                 content: Text('Failed to register')),
                //           );
                //           return;
                //         }
                //       },
                //       child: provider.isLoading
                //           ? const CircularProgressIndicator()
                //           : const Text('Register Product'),
                //     );
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
