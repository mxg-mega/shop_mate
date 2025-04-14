import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/data/datasource/local/business_storage.dart';
import 'package:shop_mate/data/models/products/product_unit.dart';
import 'package:shop_mate/data/models/unit_system/units_model.dart';
import 'package:shop_mate/providers/authentication_provider.dart';
import 'package:shop_mate/services/business_service.dart';

class ProductUnitManager extends StatefulWidget {
  final List<ProductUnit> units;
  final Function(List<ProductUnit>) onUnitsChanged;
  final double salesPrice;
  final double costPrice;

  const ProductUnitManager({
    super.key,
    required this.units,
    required this.onUnitsChanged,
    required this.salesPrice,
    required this.costPrice,
  });

  @override
  _ProductUnitManagerState createState() => _ProductUnitManagerState();
}

class _ProductUnitManagerState extends State<ProductUnitManager> {
  void _addUnit() async {
    // Show dialog for entering unit details
    final newUnit = await showShadDialog<ProductUnit>(
      context: context,
      builder: (context) => AddUnitDialog(
        costPrice: widget.costPrice,
        salesPrice: widget.salesPrice,
      ),
    );
    if (newUnit != null) {
      setState(() {
        widget.units.add(newUnit);
      });
      widget.onUnitsChanged(widget.units);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Product Units', style: ShadTheme.of(context).textTheme.h4),
        ListView.builder(
          shrinkWrap: true,
          itemCount: widget.units.length,
          itemBuilder: (context, index) {
            final unit = widget.units[index];
            return ListTile(
              title: Text(unit.unit.name),
              subtitle: Text('Conversion: ${unit.unit.conversionRate}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ShadButton.secondary(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showShadDialog<ProductUnit>(
                        context: context,
                        builder: (context) => AddUnitDialog(
                          costPrice: widget.costPrice,
                          salesPrice: widget.salesPrice,
                          unit: unit,
                        ),
                      ).then(
                        (updatedUnit) {
                          if (updatedUnit != null) {
                            setState(() {
                              widget.units[index] = updatedUnit;
                            });
                          }
                        },
                      );
                    },
                  ),
                  ShadButton.secondary(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        widget.units.removeAt(index);
                      });
                      widget.onUnitsChanged(widget.units);
                    },
                  ),
                ],
              ),
            );
          },
        ),
        ShadButton(
          onPressed: _addUnit,
          child: Text('Add Unit'),
        ),
      ],
    );
  }
}

///////////////////////////////////// ADD UNIT DIALOG /////////////////////////////////////
class AddUnitDialog extends StatefulWidget {
  const AddUnitDialog({
    super.key,
    this.unit,
    required this.costPrice,
    required this.salesPrice,
  });

  final ProductUnit? unit;
  final double costPrice;
  final double salesPrice;

  @override
  _AddUnitDialogState createState() => _AddUnitDialogState();
}

class _AddUnitDialogState extends State<AddUnitDialog> {
  final _formKey = GlobalKey<FormState>();
  final _unitNameController = TextEditingController();
  final _conversionRateController = TextEditingController();
  final _costPriceController = TextEditingController();
  final _salesPriceController = TextEditingController();
  bool isBaseUnit = false;
  Unit? selectedUnit;
  List<Unit> availableUnits = [];

  @override
  void initState() {
    super.initState();
    // Initialize your availableUnits list here.

    availableUnits = BusinessService
        .instance.currentBusiness!.businessSettings!.unitSystem.units.values
        .map((unit) => unit.copyWith())
        .toList()
        .reversed
        .toList();
    // For example:
    // availableUnits = [];
    //   Unit(name: 'unit', symbol: 'unit', conversionRate: 1),
    //   Unit(name: 'box', symbol: 'box', conversionRate: 10),
    //   Unit(name: 'kg', symbol: 'kg', conversionRate: 1),
    //   Unit(name: 'gram', symbol: 'gram', conversionRate: 0.001),
    //   Unit(name: 'liter', symbol: 'l', conversionRate: 1),
    //   Unit(name: 'milliliter', symbol: 'ml', conversionRate: 0.001),
    //   // Add more units as needed
    // ];
    if (availableUnits.isNotEmpty) {
      selectedUnit = availableUnits.first;
    }

    if (widget.unit != null) {
      _unitNameController.text = widget.unit!.unit.name;
      _conversionRateController.text =
          widget.unit!.unit.conversionRate.toString();
      _costPriceController.text = widget.unit!.costPrice.toString();
      _salesPriceController.text = widget.unit!.price.toString();
      isBaseUnit = widget.unit!.isBaseUnit;
      // selectedUnit = widget.unit!.unit;
    }
  }

  @override
  void dispose() {
    _unitNameController.dispose();
    _conversionRateController.dispose();
    _costPriceController.dispose();
    _salesPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: ShadDialog(
        title: Text('Add New Unit'),
        actions: <Widget>[
          ShadButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ShadButton(
            child: Text('Add'),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final conversionRate =
                    double.parse(_conversionRateController.text);
                final costPrice = double.parse(_costPriceController.text);
                final salesPrice = double.parse(_salesPriceController.text);

                final newUnit = ProductUnit(
                  unit: selectedUnit!.copyWith(conversionRate: conversionRate),
                  costPrice: costPrice,
                  price: salesPrice,
                  isBaseUnit: isBaseUnit,
                );

                Navigator.of(context).pop(newUnit);
              }
            },
          ),
        ],
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Unit Selection
                  ShadSelectFormField<Unit>(
                    label: Text('Unit'),
                    itemCount: availableUnits.length,
                    initialValue: selectedUnit,
                    options: availableUnits
                        .map(
                          (unit) => ShadOption(
                            value: unit,
                            child: Text(unit.name),
                          ),
                        )
                        .toList(),
                    selectedOptionBuilder: (context, value) => Text(value.name),
                    // Display the selected unit's name
                    validator: (selectedUnit) {
                      // You can add validation logic here if needed
                      if (selectedUnit == null) {
                        return "Please select a Unit";
                      }
                      this.selectedUnit = selectedUnit;
                      return null;
                    },
                  ),

                  // Conversion Rate
                  ShadInputFormField(
                    controller: _conversionRateController,
                    label: Text('Conversion Rate'),
                    decoration: ShadDecoration(),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a conversion rate';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),

                  // Cost Price
                  ShadInputFormField(
                    controller: _costPriceController,
                    label: Text('Cost Price'),
                    keyboardType: TextInputType.number,
                    enabled: !isBaseUnit,
                    validator: (value) {
                      if (!isBaseUnit && (value == null || value.isEmpty)) {
                        return 'Please enter a cost price';
                      }
                      if (!isBaseUnit && (double.tryParse(value) == null)) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),

                  // Sales Price
                  ShadInputFormField(
                    controller: _salesPriceController,
                    label: Text('Sales Price'),
                    decoration: ShadDecoration(),
                    keyboardType: TextInputType.number,
                    enabled: !isBaseUnit,
                    validator: (value) {
                      if (!isBaseUnit && (value == null || value.isEmpty)) {
                        return 'Please enter a sales price';
                      }
                      if (!isBaseUnit && (double.tryParse(value) == null)) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),

                  // Is Base Unit
                  CheckboxListTile(
                    title: Text('Is Base Unit'),
                    value: isBaseUnit,
                    onChanged: (value) {
                      setState(() {
                        isBaseUnit = value!;
                        _costPriceController.text = widget.costPrice.toString();
                        _salesPriceController.text =
                            widget.salesPrice.toString();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
