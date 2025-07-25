import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/expense.dart';
import '../models/payment.dart';

class LedgerRepository {
  final _client = Supabase.instance.client;

  Future<List<Expense>> fetchExpenses() async {
    try {
      final response = await _client
          .from('expenses')
          .select()
          .order('due_date', ascending: false);
      return (response as List)
          .map((json) {
            final map = Map<String, dynamic>.from(json as Map);
            return Expense.fromJson({
              'id': map['id'] ?? '',
              'title': map['title'] ?? '',
              'description': map['description'] ?? '',
              'amount': (map['amount'] ?? 0.0).toDouble(),
              'category': map['category'] ?? 'other',
              'type': map['type'] ?? 'expense',
              'dueDate': map['due_date'] ?? DateTime.now().toIso8601String(),
              'createdAt': map['created_at'] ?? DateTime.now().toIso8601String(),
              'apartmentNo': map['apartment_no'],
              'status': map['status'] ?? 'pending',
            });
          })
          .toList();
    } catch (e) {
      print('Error fetching expenses: $e');
      return [];
    }
  }

  Future<List<Payment>> fetchPayments() async {
    try {
      final response = await _client
          .from('payments')
          .select()
          .order('paid_at', ascending: false);
      return (response as List)
          .map((json) {
            final map = Map<String, dynamic>.from(json as Map);
            return Payment.fromJson({
              'id': map['id'] ?? '',
              'expenseId': map['expense_id'] ?? '',
              'userId': map['user_id'] ?? '',
              'apartmentNo': map['apartment_no'] ?? '',
              'amount': (map['amount'] ?? 0.0).toDouble(),
              'paymentMethod': map['payment_method'] ?? 'bank_transfer',
              'paidAt': map['paid_at'] ?? DateTime.now().toIso8601String(),
              'notes': map['notes'],
              'receiptUrl': map['receipt_url'],
            });
          })
          .toList();
    } catch (e) {
      print('Error fetching payments: $e');
      return [];
    }
  }

  Future<void> createExpense({
    required String title,
    required String description,
    required double amount,
    required String category,
    required String type,
    required DateTime dueDate,
    String? apartmentNo,
  }) async {
    await _client.from('expenses').insert({
      'title': title,
      'description': description,
      'amount': amount,
      'category': category,
      'type': type,
      'due_date': dueDate.toIso8601String(),
      'apartment_no': apartmentNo,
      'status': 'pending',
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> recordPayment({
    required String expenseId,
    required String userId,
    required String apartmentNo,
    required double amount,
    required String paymentMethod,
    String? notes,
    String? receiptUrl,
  }) async {
    await _client.from('payments').insert({
      'expense_id': expenseId,
      'user_id': userId,
      'apartment_no': apartmentNo,
      'amount': amount,
      'payment_method': paymentMethod,
      'paid_at': DateTime.now().toIso8601String(),
      'notes': notes,
      'receipt_url': receiptUrl,
    });

    // Update expense status to paid
    await _client
        .from('expenses')
        .update({'status': 'paid'})
        .eq('id', expenseId);
  }
} 