import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense.freezed.dart';
part 'expense.g.dart';

@freezed
class Expense with _$Expense {
  const factory Expense({
    required String id,
    required String title,
    required String description,
    required double amount,
    required String category, // 'monthly_dues', 'utilities', 'maintenance', 'security', 'other'
    required String type, // 'expense' or 'income'
    required DateTime dueDate,
    required DateTime createdAt,
    String? apartmentNo, // null for building-wide expenses
    required String status, // 'pending', 'paid', 'overdue'
  }) = _Expense;

  factory Expense.fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);
} 