// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TicketCommentImpl _$$TicketCommentImplFromJson(Map<String, dynamic> json) =>
    _$TicketCommentImpl(
      id: json['id'] as String,
      ticketId: json['ticketId'] as String,
      userId: json['userId'] as String,
      body: json['body'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      userName: json['userName'] as String?,
      userAvatarUrl: json['userAvatarUrl'] as String?,
    );

Map<String, dynamic> _$$TicketCommentImplToJson(_$TicketCommentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ticketId': instance.ticketId,
      'userId': instance.userId,
      'body': instance.body,
      'createdAt': instance.createdAt.toIso8601String(),
      'userName': instance.userName,
      'userAvatarUrl': instance.userAvatarUrl,
    };
