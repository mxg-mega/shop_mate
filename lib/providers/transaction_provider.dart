import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_mate/core/error/error_toaster.dart';
import 'package:shop_mate/core/utils/constants.dart';
import 'package:shop_mate/data/models/transaction/transaction.dart';
import 'package:shop_mate/services/transaction_service.dart';

class TransactionProvider extends ChangeNotifier {
  final TransactionService _transactionService = TransactionService();

  List<Transactions> _allTransactions = [];
  List<Transactions> _currentPageTransactions = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMoreTransactions = true;
  DocumentSnapshot? _lastDocument;
  String? _searchProductID;
  TransactionsType? _searchTransactionType;
  String? _searchBusinessID;

  List<Transactions> get transactions => (_searchProductID == null &&
          _searchTransactionType == null &&
          _searchBusinessID == null)
      ? _currentPageTransactions
      : _allTransactions;

  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMoreTransactions => _hasMoreTransactions;

  String? get searchProductID => _searchProductID;
  TransactionsType? get searchTransactionType => _searchTransactionType;
  String? get searchBusinessID => _searchBusinessID;

  Future<void> fetchInitialTransactions({int limit = 20}) async {
    _isLoading = true;
    notifyListeners();
    try {
      _resetPagination();
      final transactions =
          await _transactionService.fetchTransactionsPaginated(limit: limit);
      if (transactions.isNotEmpty) {
        _allTransactions = transactions;
        _currentPageTransactions = transactions;
        _lastDocument = await _getLastDocument(transactions.last.id);
        notifyListeners();
      }
    } catch (e) {
      ErrorNotificationService.showErrorToaster(
        message: e.toString(),
        isDestructive: true,
      );
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Transactions>> transactionsByItemId(String itemId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final transactions =
          await _transactionService.fetchTransactionsByItemId(itemId);
      return transactions;
    } catch (e) {
      ErrorNotificationService.showErrorToaster(
        message: e.toString(),
        isDestructive: true,
      );
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTransactionsByProductId(String productId,
      {int limit = 20}) async {
    _isLoading = true;
    notifyListeners();
    try {
      _resetPagination();
      final transactions = await _transactionService
          .fetchTransactionsByProductId(productId, limit: limit);
      logger.d('Transactions by product ID: ${transactions.length}');
      if (transactions.isNotEmpty) {
        _allTransactions = transactions;
        _currentPageTransactions = transactions;
        _lastDocument = await _getLastDocument(transactions.last.id);
        notifyListeners();
      }
    } catch (e) {
      ErrorNotificationService.showErrorToaster(
        message: e.toString(),
        isDestructive: true,
      );
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Transactions>> fetchInventoryItemTransactions(
      String itemId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final transactions =
          await _transactionService.fetchTransactionsByItemId(itemId);
      return transactions;
    } catch (e) {
      ErrorNotificationService.showErrorToaster(
        message: 'Failed to Fetch Transactions',
        description: e.toString(),
        isDestructive: true,
      );
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<DocumentSnapshot?> _getLastDocument(String id) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection(Storage.transactions)
          .doc(id)
          .get();
      return doc;
    } catch (e) {
      return null;
    }
  }

  Future<void> loadMoreTransactions({int limit = 20}) async {
    if (_isLoadingMore || !_hasMoreTransactions) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final newTransactions =
          await _transactionService.fetchTransactionsPaginated(
        limit: limit,
        lastDocument: _lastDocument,
      );

      if (newTransactions.isEmpty) {
        _hasMoreTransactions = false;
      } else {
        _allTransactions.addAll(newTransactions);
        _currentPageTransactions = _allTransactions;
        _lastDocument = await _getLastDocument(newTransactions.last.id);
        notifyListeners();
      }
    } catch (e) {
      ErrorNotificationService.showErrorToaster(
        message: e.toString(),
        isDestructive: true,
      );
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> searchTransactions({
    String? productID,
    TransactionsType? transactionType,
    String? businessID,
    int limit = 20,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      _searchProductID = productID;
      _searchTransactionType = transactionType;
      _searchBusinessID = businessID;
      _resetPagination();

      final transactions = await _transactionService.queryTransactions(
        productID: productID,
        transactionType: transactionType,
        businessID: businessID,
        limit: limit,
      );

      if (transactions.isNotEmpty) {
        _allTransactions = transactions;
        _currentPageTransactions = transactions;
        _lastDocument = await _getLastDocument(transactions.last.id);
        notifyListeners();
      }
    } catch (e) {
      ErrorNotificationService.showErrorToaster(
        message: e.toString(),
        isDestructive: true,
      );
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    _searchProductID = null;
    _searchTransactionType = null;
    _searchBusinessID = null;
    _allTransactions = [];
    _currentPageTransactions = [];
    _hasMoreTransactions = true;
    _lastDocument = null;
    notifyListeners();
  }

  Future<void> addTransaction(Transactions transaction) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _transactionService.saveTransaction(transaction);
      _allTransactions.insert(0, transaction);
      _currentPageTransactions = _allTransactions;
      notifyListeners();
    } catch (e) {
      ErrorNotificationService.showErrorToaster(
        message: e.toString(),
        isDestructive: true,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTransaction(
      String transactionId, Transactions transaction) async {
    try {
      await _transactionService.updateTransaction(
          transactionId, transaction.toJson());
      final index = _allTransactions.indexWhere((t) => t.id == transaction.id);
      if (index != -1) {
        _allTransactions[index] = transaction;
        _currentPageTransactions = _allTransactions;
        notifyListeners();
      }
    } catch (e) {
      ErrorNotificationService.showErrorToaster(
        message: e.toString(),
        isDestructive: true,
      );
    }
  }

  Future<void> deleteTransaction(String transactionId) async {
    try {
      await _transactionService.deleteTransaction(transactionId);
      _allTransactions.removeWhere((t) => t.id == transactionId);
      _currentPageTransactions = _allTransactions;
      notifyListeners();
    } catch (e) {
      ErrorNotificationService.showErrorToaster(
        message: e.toString(),
        isDestructive: true,
      );
    }
  }

  void _resetPagination() {
    _allTransactions = [];
    _currentPageTransactions = [];
    _isLoadingMore = false;
    _hasMoreTransactions = true;
    _lastDocument = null;
  }
}
