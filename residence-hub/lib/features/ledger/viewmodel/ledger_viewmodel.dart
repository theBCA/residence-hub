import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/expense.dart';
import '../models/payment.dart';
import '../repository/ledger_repository.dart';

final ledgerRepositoryProvider = Provider<LedgerRepository>((ref) => LedgerRepository());

final expensesProvider = AsyncNotifierProvider<ExpenseViewModel, List<Expense>>(ExpenseViewModel.new);
final paymentsProvider = AsyncNotifierProvider<PaymentViewModel, List<Payment>>(PaymentViewModel.new);

class ExpenseViewModel extends AsyncNotifier<List<Expense>> {
  late final LedgerRepository _repository;

  @override
  Future<List<Expense>> build() async {
    _repository = ref.read(ledgerRepositoryProvider);
    return await _repository.fetchExpenses();
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
    await _repository.createExpense(
      title: title,
      description: description,
      amount: amount,
      category: category,
      type: type,
      dueDate: dueDate,
      apartmentNo: apartmentNo,
    );
    state = const AsyncLoading();
    state = AsyncData(await _repository.fetchExpenses());
  }
}

class PaymentViewModel extends AsyncNotifier<List<Payment>> {
  late final LedgerRepository _repository;

  @override
  Future<List<Payment>> build() async {
    _repository = ref.read(ledgerRepositoryProvider);
    return await _repository.fetchPayments();
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
    await _repository.recordPayment(
      expenseId: expenseId,
      userId: userId,
      apartmentNo: apartmentNo,
      amount: amount,
      paymentMethod: paymentMethod,
      notes: notes,
      receiptUrl: receiptUrl,
    );
    state = const AsyncLoading();
    state = AsyncData(await _repository.fetchPayments());
    // Also refresh expenses to update status
    ref.invalidate(expensesProvider);
  }
} 