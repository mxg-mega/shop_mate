import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/features/migration/add_expiry_fields_to_inventory_items.dart';
import 'package:shop_mate/features/migration/inventory_migration.dart';
import 'package:shop_mate/features/migration/migrate_business.dart';

class MigrationScreen extends StatefulWidget {
  const MigrationScreen({super.key});

  @override
  State<MigrationScreen> createState() => _MigrationScreenState();
}

class _MigrationScreenState extends State<MigrationScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Migrations'),
      ),
      body: Center(
        child: Column(
          children: [
            ShadButton(
              leading: isLoading
                  ? CircularProgressIndicator.adaptive(
                      backgroundColor:
                          ShadTheme.of(context).colorScheme.primaryForeground,
                    )
                  : null,
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                await migrateBusiness();
                setState(() {
                  isLoading = false;
                });
              },
              child: Text('Migrate Business'),
            ),
            ShadButton(
              leading: isLoading
                  ? CircularProgressIndicator.adaptive(
                      backgroundColor:
                          ShadTheme.of(context).colorScheme.primaryForeground,
                    )
                  : null,
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                await addNotesField();
                setState(() {
                  isLoading = false;
                });
              },
              child: Text('Migrate inventory'),
            ),
            ShadButton(
              leading: isLoading
                  ? CircularProgressIndicator.adaptive(
                      backgroundColor:
                          ShadTheme.of(context).colorScheme.primaryForeground,
                    )
                  : null,
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                await deleteDocuments();
                setState(() {
                  isLoading = false;
                });
              },
              child: Text('Delete product-inventory-transactions related documents'),
            ),
          ],
        ),
      ),
    );
  }
}
