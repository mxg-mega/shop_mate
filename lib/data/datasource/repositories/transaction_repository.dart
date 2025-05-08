import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_mate/core/utils/constants.dart';
import 'package:shop_mate/data/models/transaction/transaction.dart';
import 'package:shop_mate/services/firebase_CRUD_service.dart';

class TransactionRepository {
  static final TransactionRepository _instance =
      TransactionRepository._internal();
  factory TransactionRepository() => _instance;

  final FirebaseCRUDService<Transactions> _crudService;

  TransactionRepository._internal()
      : _crudService = FirebaseCRUDService<Transactions>(
          collectionName: Storage.transactions,
          fromJson: (data) => Transactions.fromJson(data),
        );

  CollectionReference get collection => _crudService.collection;

  Future<List<Transactions>> getAllTransactions() async {
    try {
      final response = await _crudService.getPaginated(limit: 100);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createTransaction(Transactions transaction) async {
    try {
      await _crudService.create(transaction);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTransaction(
      String transactionId, Map<String, dynamic> updates) async {
    try {
      await _crudService.update(transactionId, updates: updates);
    } catch (e) {
      rethrow;
    }
  }

  Future<Transactions?> fetchTransaction(String transactionId) async {
    try {
      final response = await _crudService.read(transactionId);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Transactions>> fetchTransactionsByItemId(String id) async {
    try {
      final querySnapshot = await _crudService.collection
          .where('productId', isEqualTo: id)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        return Transactions.fromJson(doc.data());
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Transactions>> fetchTransactionsPaginated({
    int limit = 20,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      Query query = _crudService.collection
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final querySnapshot = await query.get();
      return querySnapshot.docs.map((doc) {
        return Transactions.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTransaction(String transactionId) async {
    try {
      await _crudService.delete(transactionId);
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
      Query query = _crudService.collection;

      if (businessID != null) {
        query = query.where('businessId', isEqualTo: businessID);
      }
      if (productID != null) {
        query = query.where('productId', isEqualTo: productID);
      }
      if (transactionType != null) {
        query = query.where('transactionType',
            isEqualTo: transactionType.name);
      }

      query = query.orderBy('createdAt', descending: true).limit(limit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final querySnapshot = await query.get();
      return querySnapshot.docs.map((doc) {
        return Transactions.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }
}
