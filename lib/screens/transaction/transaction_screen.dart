import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_mate/data/models/transaction/transaction.dart';
import 'package:shop_mate/providers/transaction_provider.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final ScrollController _scrollController = ScrollController();
  String? _selectedProductID;
  TransactionsType? _selectedTransactionsType;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<TransactionProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // provider.initStream();
      provider.fetchInitialTransactions();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (!provider.isLoadingMore && provider.hasMoreTransactions) {
          provider.loadMoreTransactions();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onFilterChanged() {
    final provider = Provider.of<TransactionProvider>(context, listen: false);
    provider.searchTransactions(
      productID: _selectedProductID,
      transactionType: _selectedTransactionsType,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: Consumer<TransactionProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading && provider.transactions.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.transactions.isEmpty) {
                  return const Center(child: Text('No transactions found.'));
                }
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: provider.transactions.length +
                      (provider.hasMoreTransactions ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == provider.transactions.length) {
                      if (provider.isLoadingMore) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }
                    final transaction = provider.transactions[index];
                    return ListTile(
                      title: Text(transaction.name),
                      subtitle: Text(
                          "Type: ${transaction.transactionsType.name}, Quantity: ${transaction.quantity ?? 'N/A'}"),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'delete') {
                            provider.deleteTransaction(transaction.id);
                          } else if (value == 'update') {
                            // TODO: Implement update logic or navigation to update screen
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                              value: 'update', child: Text('Update')),
                          const PopupMenuItem(
                              value: 'delete', child: Text('Delete')),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Filter by Product ID',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _selectedProductID = value.isEmpty ? null : value;
                });
                _onFilterChanged();
              },
            ),
          ),
          const SizedBox(width: 8),
          DropdownButton<TransactionsType>(
            hint: const Text('Transaction Type'),
            value: _selectedTransactionsType,
            items: TransactionsType.values.map((TransactionsType type) {
              return DropdownMenuItem<TransactionsType>(
                value: type,
                child: Text(type.toString().split('.').last),
              );
            }).toList(),
            onChanged: (TransactionsType? newValue) {
              setState(() {
                _selectedTransactionsType = newValue;
              });
              _onFilterChanged();
            },
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _selectedProductID = null;
                _selectedTransactionsType = null;
              });
              _onFilterChanged();
            },
          ),
        ],
      ),
    );
  }
}
