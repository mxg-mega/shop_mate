import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_mate/data/datasource/repositories/transaction_repository.dart';
import 'package:shop_mate/data/models/transaction/transaction.dart';
import 'package:uuid/uuid.dart';

class TransactionService {
  static final TransactionService _instance = TransactionService._internal();

  final TransactionRepository _repo;

  TransactionService._internal() : _repo = TransactionRepository();

  factory TransactionService() {
    return _instance;
  }

  Future<List<Transactions>> fetchAllTransactions() async {
    try {
      final response = await _repo.getAllTransactions();
      return response;
    } catch (e) {
      throw Exception('Could not fetch Transactions');
    }
  }

  Future<void> saveTransaction(Transactions transaction) async {
    try {
      await _repo.createTransaction(transaction);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createTransactionForProductCreation({
    required String productId,
    required String businessId,
    required String productName,
    required double? quantity,
    String? notes,
  }) async {
    final transaction = Transactions(
      id: const Uuid().v4(),
      name: 'Product Creation: $productName',
      businessId: businessId,
      productId: productId,
      transactionsType: TransactionsType.supply,
      quantity: quantity?.toStringAsFixed(2) ?? (0.0).toString(),
      notes: notes ?? 'Transaction created for product creation',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await saveTransaction(transaction);
  }

  Future<void> createTransactionForInventoryItemCreation({
    required String inventoryItemId,
    required String businessId,
    required String productId,
    required double? quantity,
    String? notes,
  }) async {
    final transaction = Transactions(
      id: const Uuid().v4(),
      name: 'Inventory Item Creation: $inventoryItemId',
      businessId: businessId,
      productId: inventoryItemId,
      transactionsType: TransactionsType.supply,
      quantity: quantity?.toStringAsFixed(2) ?? (0.0).toString(),
      notes: notes ?? 'Transaction created for inventory item creation',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await saveTransaction(transaction);
  }

  Future<void> updateTransaction(
      String transactionId, Map<String, dynamic> updates) async {
    try {
      await _repo.updateTransaction(transactionId, updates);
    } catch (e) {
      rethrow;
    }
  }

  Future<Transactions?> fetchTransaction(String transactionId) async {
    try {
      return await _repo.fetchTransaction(transactionId);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Transactions>> fetchTransactionsByItemId(String id) async {
    try{
      final response = await _repo.fetchTransactionsByItemId(id);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Transactions>> fetchTransactionsPaginated({
    int limit = 20,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      return await _repo.fetchTransactionsPaginated(
        limit: limit,
        lastDocument: lastDocument,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTransaction(String transactionId) async {
    try {
      await _repo.deleteTransaction(transactionId);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Transactions>> queryTransactions({
    String? productID,
    TransactionsType? transactionType,
    String? businessID,
    int limit = 20,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      return await _repo.queryTransactions(
        productID: productID,
        transactionType: transactionType,
        businessID: businessID,
        limit: limit,
        lastDocument: lastDocument,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Transactions>> fetchTransactionsByProductId(
      String productId,
      {int limit = 20,
      DocumentSnapshot? lastDocument}) async {
    try {
      final response = await queryTransactions(
        productID: productId,
        limit: limit,
        lastDocument: lastDocument,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
