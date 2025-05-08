import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/core/utils/constants.dart';
import 'package:shop_mate/data/datasource/local/business_storage.dart';
import 'package:shop_mate/data/datasource/repositories/inventory_repository.dart';
import 'package:shop_mate/data/models/inventory/inventory_item_model.dart';
import 'package:shop_mate/data/models/products/product_model.dart';
import 'package:shop_mate/data/models/products/product_unit.dart';
import 'package:shop_mate/features/responsive_design/layouts/responsive_layout.dart';
import 'package:shop_mate/providers/authentication_provider.dart';
import 'package:shop_mate/providers/inventory_provider.dart';
import 'package:shop_mate/providers/product_provider.dart';
import 'package:shop_mate/screens/inventory/inventory_item_registration_screen.dart';
import 'package:shop_mate/screens/inventory/widgets/location_selector_widget.dart';
import 'package:shop_mate/screens/products/product_unit_manager.dart';
import 'package:shop_mate/services/business_service.dart';
import 'package:uuid/uuid.dart';

import '../../core/utils/constants_enums.dart';

class RegisterProductScreen extends StatefulWidget {
  const RegisterProductScreen({super.key, this.sku});

  final String? sku; // Nullable SKU parameter

  @override
  State<RegisterProductScreen> createState() => _RegisterProductScreenState();
}

class _RegisterProductScreenState extends State<RegisterProductScreen> {
  final _formKey = GlobalKey<ShadFormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _costPriceController = TextEditingController();
  final TextEditingController _salesPriceController = TextEditingController();
  final TextEditingController _skuController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  // final bool hasExpiryDate;
  // final DateTime expiryDate;
  bool hasExpiryDate = true;

  ProductCategory? _selectedCategory;
  List<ProductUnit> productUnits =
      Product.defaultProductUnits.map((unit) => unit.copyWith()).toList();
  DateTime? expiryDate;

  Product? _registeredProduct = null;

  @override
  void initState() {
    super.initState();
  }

  List<Widget> _buildExpiryDateWidget(bool isRow) {
    return [
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
    final provider = Provider.of<ProductProvider>(context);
    final authProv = Provider.of<AuthenticationProvider>(context);
    final theme = ShadTheme.of(context);
    final inventoryProvider = Provider.of<InventoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: ShadButton.ghost(
          child: Icon(LucideIcons.arrowLeft),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Register Product'),
        actions: [
          ShadButton.secondary(
            child: Text('Add Inventory'),
            onPressed: () {
              // takes user to the inventory item registrayion page
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => InventoryItemRegistrationScreen(
                    // TODO: Pass the product ID to the InventoryItemRegistrationScreen
                    // most likely it should be after a registration of a product has been made,
                    // then pass it here so we will use the product ID to create the inventory item
                    // use the provider to see if the product is already registered after submission
                    productId: _registeredProduct!.id,
                  ),
                ),
              );
            },
          )
        ],
        actionsPadding: EdgeInsets.only(left: 5.w),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ShadForm(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Basic Information',
                  style: theme.textTheme.h3,
                ),
                const Perimeter(
                  height: 2,
                ),
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
                      .map((category) => ShadOption(
                          value: category, child: Text(category.name)))
                      .toList(),
                  selectedOptionBuilder: (context, category) =>
                      category == ProductCategory.none
                          ? const Text('Please Select a Product Category')
                          : Text(category.name),
                ),
                Perimeter(height: 2),
                ShadInputFormField(
                  maxLines: 5,
                  controller: _descriptionController,
                  label: Text('Description'),
                  placeholder: Text('Product Description...'),
                ),
                Perimeter(height: 5),
                Text('Pricing', style: theme.textTheme.h3),
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
                        placeholder: Text('Quantity'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ShadButton.outline(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                final currentValue =
                                    int.tryParse(_quantityController.text) ?? 0;
                                if (currentValue > 0) {
                                  setState(() {
                                    _quantityController.text =
                                        (currentValue - 1).toString();
                                  });
                                }
                              },
                            ),
                            ShadButton.outline(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                final currentValue =
                                    int.tryParse(_quantityController.text) ?? 0;
                                setState(() {
                                  _quantityController.text =
                                      (currentValue + 1).toString();
                                });
                              },
                            ),
                          ],
                        ),
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
                  ],
                ),
                Perimeter(height: 2),
                // New SKU/Barcode widget implementation (commented out for now)
                /*
                ShadInputFormField(
                  controller: _skuController,
                  label: const Text('SKU/Barcode'),
                  placeholder: const Text('Scan or Enter SKU/Barcode'),
                  trailing: IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: () async {
                  try {
                  // Simulate barcode scanning functionality
                  final scannedBarcode = await scanBarcode();
                  if (scannedBarcode != null) {
                    setState(() {
                    _skuController.text = scannedBarcode;
                    });
                  }
                  } catch (e) {
                  // If scanning fails, prompt user to enter manually
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                    content: Text(
                    'Failed to scan barcode. Please enter manually.'),
                    ),
                  );
                  }
                  },
                  ),
                  validator: (value) {
                  if (value == null || value.isEmpty) {
                  return 'Please enter or scan a valid SKU/Barcode';
                  }
                  return null;
                  },
                );

                // Template for barcode lookup functionality
                Future<Map<String, dynamic>?> lookupBarcode(String barcode) async {
                  // TODO: Implement barcode lookup logic here
                  // Example: Query a public database or API to fetch product details
                  // Return a map of product details or null if not found
                  return null;
                }

                // Simulated barcode scanning function
                Future<String?> scanBarcode() async {
                  // TODO: Integrate with a barcode scanning library
                  // Example: Use a package like `mobile_scanner` or `barcode_scan2`
                  return null; // Replace with actual scanned barcode
                }
                */
                ShadInputFormField(
                  controller: _skuController,
                  label: const Text('SKU/Barcode'),
                  placeholder: Text('This is Temporarily Disabled'),
                  enabled: false,
                ),
                Perimeter(height: 5),
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
                Perimeter(height: 5),
                Text(
                  'Additional Information',
                  style: theme.textTheme.h3,
                ),
                Perimeter(height: 2),
                Text(
                  'Select Expiry Date',
                  style: theme.textTheme.h4,
                ),
                if (ResponsiveLayout.isMobile(context))
                  Column(
                    children: _buildExpiryDateWidget(false),
                  )
                else
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildExpiryDateWidget(true),
                  ),
                Perimeter(height: 2),
                Text(
                  'Select location',
                  style: theme.textTheme.h4,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: BusinessService.instance.currentBusiness!.locations!
                      .map(
                        (location) => ListTile(
                          leading: ShadCheckbox(
                            value: location == _locationController.text,
                            onChanged: (value) {
                              setState(() {
                                _locationController.text = location;
                              });
                            },
                          ),
                          title: Text(
                            location,
                            style: theme.textTheme.p.copyWith(
                              fontSize: theme.textTheme.small.fontSize,
                            ),
                          ),
                        ),
                      )
                      .toList(),
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
                              stockQuantity: double.parse(
                                  _quantityController.text.isEmpty
                                      ? '0'
                                      : _quantityController.text),
                              category:
                                  _selectedCategory ?? ProductCategory.others,
                              sku: widget.sku ??
                                  Product.generateSKU(_nameController.text),
                              isActive: true,
                              productUnits: productUnits,
                              expiryDate: expiryDate,
                              description: _descriptionController.text,
                              imageUrl: '',
                              createdAt: DateTime.now(),
                              updatedAt: DateTime.now(),
                            );
                            logger.d('New Product : ${newProduct.toJson()}');
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              setState(() {
                                _registeredProduct = newProduct;
                                logger.d(
                                    'Registered Product : ${_registeredProduct?.toJson()}');
                              });
                            });
                            final newItem2 = newProduct.createInventoryItem(
                              location: _locationController.text.isEmpty
                                  ? 'Store'
                                  : _locationController.text,
                              initialStock: double.parse(
                                  _quantityController.text.isEmpty
                                      ? '0'
                                      : _quantityController.text),
                              inventoryItemId: InventoryRepository()
                                  .getCollection()
                                  .doc()
                                  .id,
                              hasExpiryDate: hasExpiryDate,
                              expiryDate: hasExpiryDate ? expiryDate : null,
                            );

                            logger.d(
                                '=====================NEW ITEM++++++++++++++\n${newItem2.toJson()}');
                            try {
                              await provider.saveProduct(newProduct);
                              await inventoryProvider
                                  .createInventoryItem(newItem2);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Failed to register product')),
                              );
                            }
                            // provider.addInventory(newItem2);
                            Navigator.of(context).pop();
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
                      ? CircularProgressIndicator(
                          color: theme.colorScheme.secondary,
                        )
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


// TODO: Look at this for future reference
/**
 * import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ProductRegistrationScreen extends StatefulWidget {
  @override
  _ProductRegistrationScreenState createState() => _ProductRegistrationScreenState();
}

class _ProductRegistrationScreenState extends State<ProductRegistrationScreen> {
  String? scannedBarcode;

  Future<void> scanBarcode() async {
    try {
      String barcode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // Scanner overlay color
        'Cancel',  // Cancel button text
        true,      // Show flash icon
        ScanMode.BARCODE,
      );
      if (barcode != '-1') {
        setState(() {
          scannedBarcode = barcode;
        });
      }
    } catch (e) {
      // Handle errors
      print('Error scanning barcode: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product Registration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: TextEditingController(text: scannedBarcode),
              decoration: InputDecoration(labelText: 'SKU (Scanned Barcode)'),
              enabled: false, // Disable the field
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: scanBarcode,
              child: Text('Scan Barcode'),
            ),
          ],
        ),
      ),
    );
  }
}
 */