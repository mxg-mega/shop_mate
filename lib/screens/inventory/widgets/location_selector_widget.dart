import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/providers/inventory_provider.dart';
import 'package:shop_mate/services/business_service.dart';

class LocationSelectorWidget extends StatelessWidget {
  final List<String> locations;
  final String? selectedLocation;
  final ValueChanged<String?> onLocationChanged;
  final TextEditingController quantityController;
  final ValueChanged<String> onQuantityChanged;
  final String? productBaseUnit;

  const LocationSelectorWidget({
    Key? key,
    required this.locations,
    required this.selectedLocation,
    required this.onLocationChanged,
    required this.quantityController,
    required this.onQuantityChanged,
    this.productBaseUnit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final inventoryProv = Provider.of<InventoryProvider>(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: locations
          .map(
            (location) => ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 8.w,
                vertical: 4.h,
              ),
              selected: selectedLocation == location,
              selectedTileColor: theme.colorScheme.primary.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              title: Text(location),
              leading: ShadCheckboxFormField(
                initialValue: selectedLocation == location,
                onChanged: (value) {
                  if (value != null && value) {
                    onLocationChanged(location);
                  } else {
                    onLocationChanged(null);
                  }
                },
              ),
              subtitle: Text(
                'Available: ${inventoryProv.getLocationStock(location)}',
                style: theme.textTheme.small.copyWith(
                  color: theme.colorScheme.mutedForeground,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Quantity: ',
                    style: theme.textTheme.small.copyWith(
                      color: theme.colorScheme.mutedForeground,
                    ),
                  ),
                  SizedBox(
                    width: 40.w,
                    child: ShadInputFormField(
                      controller: quantityController,
                      placeholder: const Text('e.g 10, 20 etc.'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid quantity';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                      onChanged: onQuantityChanged,
                    ),
                  ),
                  Text(
                    ' ${productBaseUnit ?? ''}',
                    style: theme.textTheme.small.copyWith(
                      color: theme.colorScheme.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
