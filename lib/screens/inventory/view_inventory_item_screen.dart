import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/core/utils/constants_enums.dart';
import 'package:shop_mate/core/utils/currency_formatter.dart';
import 'package:shop_mate/data/models/inventory/inventory_model.dart';
import 'package:shop_mate/data/models/transaction/transaction.dart';
import 'package:shop_mate/providers/inventory_provider.dart';
import 'package:shop_mate/data/models/inventory/inventory_item_model.dart';
import 'package:shop_mate/providers/transaction_provider.dart';

class ViewInventoryItemScreen extends StatefulWidget {
  const ViewInventoryItemScreen({super.key, required this.item});

  final InventoryItem item;

  @override
  State<ViewInventoryItemScreen> createState() =>
      _ViewInventoryItemScreenState();
}

class _ViewInventoryItemScreenState extends State<ViewInventoryItemScreen> {
  List<Transactions>? transactions = [];
  // ShadTabsController<String> _tabsController =
  //     ShadTabsController<String>(value: 'additional-info');

  List<String> headers = [
    'Transaction ID',
    'Date',
    'Type',
    'Quantity',
    'Notes',
  ];
  List<List<String?>> body = [];

  ScrollController _horizontalScrollController = ScrollController();
  ScrollController _verticalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Fetch transactions for the item
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      transactions =
          await Provider.of<TransactionProvider>(context, listen: false)
              .fetchInventoryItemTransactions(widget.item.id);
      body = transactions!
          .map((item) => [
                item.id,
                item.createdAt?.toString().split(' ')[0],
                item.transactionsType.name,
                item.quantity,
                item.notes,
              ])
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final inventoryProvider = Provider.of<InventoryProvider>(context);
    Color? containerColor;
    Color? textColor;
    final theme = ShadTheme.of(context);

    switch (widget.item.status) {
      case InventoryStatus.inStock:
        containerColor = Colors.green.withOpacity(0.3);
        textColor = Colors.green;
        break;
      case InventoryStatus.lowStock:
        containerColor = Colors.amber.withOpacity(0.3);
        textColor = Colors.amber;
        break;
      case InventoryStatus.outOfStock:
        containerColor = Colors.red.withOpacity(0.3);
        textColor = Colors.red;
        break;
      case InventoryStatus.onOrder:
        containerColor = Colors.blue.withOpacity(0.3);
        textColor = Colors.blue;
    }

    return Scaffold(
      appBar: AppBar(
        leading: ShadButton.ghost(
          child: Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Inventory Item Details',
          style: theme.textTheme.h2.copyWith(fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShadCard(
                title: Text(widget.item.name),
                description: Text('Item ID: ${widget.item.id}'),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Perimeter(height: 2),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 1.h),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: containerColor,
                        ),
                        child: Text(
                          widget.item.status.name.replaceFirst('i', 'I'),
                          style: TextStyle(color: textColor),
                        ),
                      ),
                      Perimeter(height: 2),
                      _buildInfoContainer(
                        theme,
                        icon: LucideIcons.boxes,
                        title: 'Current Quantity',
                        subTitle:
                            '${widget.item.quantity.toStringAsFixed(2)} ${widget.item.baseUnit}',
                      ),
                      Perimeter(height: 2),
                      _buildInfoContainer(
                        theme,
                        icon: LucideIcons.map,
                        title: 'Location',
                        subTitle: widget.item.location!,
                      ),
                      Perimeter(height: 2),
                      _buildInfoContainer(
                        theme,
                        icon: LucideIcons.clock,
                        title: 'Last Updated',
                        subTitle:
                            '${widget.item.updatedAt!.getOrdinalDay()}/${widget.item.updatedAt!.month}/${widget.item.updatedAt!.year}',
                      ),
                      Perimeter(height: 3),
                      Row(
                        children: [
                          Icon(
                            LucideIcons.dollarSign,
                            // size: 10.w,
                            size: theme.textTheme.h4.fontSize! * 1.5,
                            color: theme.colorScheme.mutedForeground,
                          ),
                          Perimeter(width: 1),
                          Text('Pricing Information',
                              style: theme.textTheme.h4),
                        ],
                      ),
                      Perimeter(height: 2),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: theme.colorScheme.muted),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: _infoTile(theme,
                                      title: 'Cost Price',
                                      subTitle:
                                          '${formatPrice(price: widget.item.costPrice)}/${widget.item.baseUnit}'),
                                ),
                                Flexible(
                                  child: _infoTile(theme,
                                      title: 'Sales Price',
                                      subTitle:
                                          '${formatPrice(price: widget.item.salesPrice)}/${widget.item.baseUnit}'),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: _infoTile(theme,
                                      title: 'Profit Marging',
                                      subTitle:
                                          '${((widget.item.salesPrice - widget.item.costPrice) / widget.item.salesPrice * 100).toStringAsFixed(2)}%'),
                                ),
                                Flexible(
                                  child: _infoTile(theme,
                                      title: 'Inventory Value',
                                      subTitle: formatPrice(
                                          price: (widget.item.quantity *
                                              widget.item.costPrice))),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Perimeter(
                height: 2,
              ),
              ShadTabs<String>(
                value: 'additional-info',
                // tabBarConstraints: const BoxConstraints(maxWidth: 400),
                // contentConstraints: const BoxConstraints(maxWidth: 400),
                tabs: [
                  ShadTab(
                    value: 'additional-info',
                    content: ShadCard(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Perimeter(
                            height: 2,
                          ),
                          Text('Item Information',
                              style: theme.textTheme.h4.copyWith(
                                  fontSize: theme.textTheme.h4.fontSize! + 2)),
                          Perimeter(
                            height: 2,
                          ),
                          infoBox(
                            theme,
                            title: 'Product ID',
                            subTitle: widget.item.id,
                          ),
                          Perimeter(
                            height: 2,
                          ),
                          infoBox(
                            theme,
                            title: 'Base Unit',
                            subTitle: widget.item.baseUnit,
                          ),
                          Perimeter(
                            height: 3,
                          ),
                          Text('Additional Information',
                              style: theme.textTheme.h4.copyWith(
                                  fontSize: theme.textTheme.h4.fontSize! + 2)),
                          Perimeter(
                            height: 2,
                          ),
                          infoBox(
                            theme,
                            title: 'Created At',
                            subTitle:
                                widget.item.createdAt.toString().split(' ')[0],
                          ),
                          Perimeter(
                            height: 2,
                          ),
                          infoBox(
                            theme,
                            title: 'Last Updated At',
                            subTitle:
                                widget.item.updatedAt.toString().split(' ')[0],
                          ),
                        ],
                      ),
                    ),
                    child: Text('Item Details'),
                  ),
                  ShadTab(
                    value: 'transaction-history',
                    content: ShadCard(
                      child: Consumer<TransactionProvider>(
                        builder: (context, provider, child) =>
                            _buildTransactionHistoryCard(theme, provider),
                      ),
                    ),
                    child: Text('Transaction History'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShadButton(
                      onPressed: () {
                        // Navigator.pushNamed(context, '/editProduct',
                        //     arguments: widget.productId);
                      },
                      child: Text('Edit Product'),
                    ),
                    ShadButton.destructive(
                      onPressed: () {
                        inventoryProvider.deleteInventoryItem(widget.item);
                        Navigator.pop(context);
                      },
                      child: Text('Delete Product'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionHistoryCard(
      ShadThemeData theme, TransactionProvider transactionProvider) {
    return TransactionsTable(
        transactions: transactions,
        verticalScrollController: _verticalScrollController,
        horizontalScrollController: _horizontalScrollController,
        headers: headers,
        body: body);
  }

  Column infoBox(ShadThemeData theme,
      {required String title, String? subTitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.small.copyWith(
            color: theme.colorScheme.mutedForeground,
            fontWeight: FontWeight.normal,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          subTitle ?? 'N/A',
          style: theme.textTheme.large,
        ),
      ],
    );
  }

  Widget _infoTile(
    ShadThemeData theme, {
    required String title,
    String? subTitle,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          children: [
            Text(
              title,
              style: theme.textTheme.small.copyWith(
                color: theme.colorScheme.mutedForeground,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              subTitle ?? 'N/A',
              style: theme.textTheme.large,
            ),
          ],
        ),
      ),
    );
  }

  Container _buildInfoContainer(
    ShadThemeData theme, {
    required IconData icon,
    required String title,
    required String subTitle,
  }) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: theme.colorScheme.muted),
      child: ListTile(
        leading: Icon(
          icon,
          size: 12.w,
          color: theme.colorScheme.mutedForeground,
        ),
        title: Text(title),
        titleTextStyle: theme.textTheme.small.copyWith(
          color: theme.colorScheme.mutedForeground,
          fontWeight: FontWeight.normal,
        ),
        subtitle: Text(
          subTitle,
          style: theme.textTheme.large,
        ),
      ),
    );
  }
}

class TransactionsTable extends StatefulWidget {
  const TransactionsTable({
    super.key,
    required this.transactions,
    required ScrollController verticalScrollController,
    required ScrollController horizontalScrollController,
    required this.headers,
    required this.body,
  })  : _verticalScrollController = verticalScrollController,
        _horizontalScrollController = horizontalScrollController;

  final List<Transactions>? transactions;
  final ScrollController _verticalScrollController;
  final ScrollController _horizontalScrollController;
  final List<String> headers;
  final List<List<String?>> body;

  @override
  State<TransactionsTable> createState() => _TransactionsTableState();
}

class _TransactionsTableState extends State<TransactionsTable> {
  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final transactionProvider = Provider.of<TransactionProvider>(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Transaction History',
                style: theme.textTheme.h4
                    .copyWith(fontSize: theme.textTheme.h4.fontSize! + 2)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                ShadButton.outline(
                  onPressed: () {
                    // TODO: Implement Filtering
                  },
                  child: Text('Filter'),
                ),
                ShadButton.outline(
                  onPressed: () {
                    // TODO: Implement export to different file types
                  },
                  child: Text('Export'),
                ),
              ],
            ),
          ],
        ),
        transactionProvider.isLoading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              )
            : widget.transactions == null || widget.transactions!.isEmpty
                ? Center(
                    child: Text(
                        'There are no available Transactions for this item.'),
                  )
                : SizedBox(
                    height: 500.h,
                    child: ShadTable(
                        verticalScrollController:
                            widget._verticalScrollController,
                        horizontalScrollController:
                            widget._horizontalScrollController,
                        // verticalScrollPhysics: const BouncingScrollPhysics(),
                        // horizontalScrollPhysics: const BouncingScrollPhysics(),
                        columnCount: widget.headers.length,
                        rowCount: widget.body.length,
                        // columnSpanExtent: (index) {
                        //   if (index == 2) return const FixedTableSpanExtent(130);
                        //   if (index == 3) {
                        //     return const MaxTableSpanExtent(
                        //       FixedTableSpanExtent(120),
                        //       RemainingTableSpanExtent(),
                        //     );
                        //   }
                        //   // uses the default value
                        //   return null;
                        // },
                        header: (context, columnIndex) {
                          return ShadTableCell.header(
                            child: Text(
                              widget.headers[columnIndex],
                              style: theme.textTheme.p.copyWith(
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          );
                        },
                        builder: (context, index) {
                          final transaction = widget.body[index.row];
                          // Color? containerColor;
                          // Color? textColor;
                          // final convertedToInventoryStatus = index.column != 2
                          //     ? InventoryStatus.outOfStock
                          //     : InventoryStatus.values.firstWhere((status) =>
                          //         transaction[index.column] == status.name);
                          // if (index.column != 2) {
                          //   debugPrint('============================'
                          //       '${transaction[index.column]}\n'
                          //       '${index.column}'
                          //       '================================');
                          // }
                          // //     'Stock In'
                          // // ? InventoryStatus.inStock
                          // // : transaction[2] == 'Stock Out'
                          // //     ? InventoryStatus.outOfStock
                          // //     : transaction[2] == 'On Order'
                          // //         ? InventoryStatus.onOrder
                          // //         : InventoryStatus.lowStock;

                          // switch (convertedToInventoryStatus) {
                          //   case InventoryStatus.inStock:
                          //     containerColor = Colors.green.withOpacity(0.3);
                          //     textColor = Colors.green;
                          //     break;
                          //   case InventoryStatus.lowStock:
                          //     containerColor = Colors.amber.withOpacity(0.3);
                          //     textColor = Colors.amber;
                          //     break;
                          //   case InventoryStatus.outOfStock:
                          //     containerColor = Colors.red.withOpacity(0.3);
                          //     textColor = Colors.red;
                          //     break;
                          //   case InventoryStatus.onOrder:
                          //     containerColor = Colors.blue.withOpacity(0.3);
                          //     textColor = Colors.blue;
                          // }
                          return ShadTableCell(
                            child: Text(
                              transaction[index.column] ?? 'N/A',
                              style: theme.textTheme.p.copyWith(
                                // color: textColor,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          );
                        }),
                  ),
        // ShadTable.list(
        //     header: headers
        //         .map(
        //           (header) => ShadTableCell.header(
        //             child: Text(header),
        //           ),
        //         )
        //         .toList(),
        //     columnSpanExtent: (index) {
        //       if (index == 2) return const FixedTableSpanExtent(130);
        //       if (index == 3) {
        //         return const MaxTableSpanExtent(
        //           FixedTableSpanExtent(120),
        //           RemainingTableSpanExtent(),
        //         );
        //       }
        //       // uses the default value
        //       return null;
        //     },
        //     children: transactions!.map(
        //       (transaction) {
        //         return [
        //           ShadTableCell(
        //             child: Text(transaction.id),
        //           ),
        //           ShadTableCell(
        //             child: Text(transaction.createdAt
        //                 .toString()
        //                 .split(' ')[0]),
        //           ),
        //           ShadTableCell(
        //             child: Text(transaction.transactionsType.name),
        //           ),
        //           ShadTableCell(
        //             child: Text(transaction.quantity.toString()),
        //           ),
        //           ShadTableCell(
        //             child: Text(transaction.productId.toString()),
        //           ),
        //         ];
        //       },
        //     ),
        //   ),
        // : ShadTable(
        //     columnCount: headers.length,
        //     rowCount: transactions!.length,
        //     header: (context, columnIndex) {
        //       return ShadTableCell.header(
        //         child: Text(
        //           headers[columnIndex],
        //           style: theme.textTheme.small.copyWith(
        //             fontWeight: FontWeight.normal,
        //           ),
        //         ),
        //       );
        //     },
        //     builder: (context, index) {
        //       final transaction = transactions![index.row];
        //       return ShadTableCell(
        //         child: Column(
        //           mainAxisSize: MainAxisSize.min,
        //           children: [
        //             Text(transactions![index.column].id),
        //             Text(transactions![index.column].createdAt.toString()),
        //             Text(transactions![index.column].transactionsType.name),
        //             // Text(transaction.quantity.toString()),
        //             // // Text(formatPrice(price: transaction.totalPrice)),
        //             // Text(transaction.notes ?? 'N/A'),
        //           ],
        //         ),
        //         // child: Text(transaction.name),
        //       );
        //   },
        // ),
      ],
    );
  }
}
