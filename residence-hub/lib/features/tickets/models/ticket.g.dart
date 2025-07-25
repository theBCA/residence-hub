// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TicketImpl _$$TicketImplFromJson(Map<String, dynamic> json) => _$TicketImpl(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      title: json['title'] as String,
      createdBy: json['createdBy'] as String?,
      description: json['description'] as String?,
      category: json['category'] as String?,
      status: json['status'] as String?,
      attachmentUrl: json['attachmentUrl'] as String?,
    );

Map<String, dynamic> _$$TicketImplToJson(_$TicketImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'title': instance.title,
      'createdBy': instance.createdBy,
      'description': instance.description,
      'category': instance.category,
      'status': instance.status,
      'attachmentUrl': instance.attachmentUrl,
    };
