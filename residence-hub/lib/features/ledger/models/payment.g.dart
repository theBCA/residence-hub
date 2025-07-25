// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentImpl _$$PaymentImplFromJson(Map<String, dynamic> json) =>
    _$PaymentImpl(
      id: json['id'] as String,
      expenseId: json['expenseId'] as String,
      userId: json['userId'] as String,
      apartmentNo: json['apartmentNo'] as String,
      amount: (json['amount'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String,
      paidAt: DateTime.parse(json['paidAt'] as String),
      notes: json['notes'] as String?,
      receiptUrl: json['receiptUrl'] as String?,
    );

Map<String, dynamic> _$$PaymentImplToJson(_$PaymentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'expenseId': instance.expenseId,
      'userId': instance.userId,
      'apartmentNo': instance.apartmentNo,
      'amount': instance.amount,
      'paymentMethod': instance.paymentMethod,
      'paidAt': instance.paidAt.toIso8601String(),
      'notes': instance.notes,
      'receiptUrl': instance.receiptUrl,
    };
