import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment.freezed.dart';
part 'payment.g.dart';

@freezed
class Payment with _$Payment {
  const factory Payment({
    required String id,
    required String expenseId,
    required String userId,
    required String apartmentNo,
    required double amount,
    required String paymentMethod, // 'bank_transfer', 'cash', 'card', 'online'
    required DateTime paidAt,
    String? notes,
    String? receiptUrl,
  }) = _Payment;

  factory Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);
} 