import 'package:freezed_annotation/freezed_annotation.dart';

part 'ticket_comment.freezed.dart';
part 'ticket_comment.g.dart';

@freezed
class TicketComment with _$TicketComment {
  const factory TicketComment({
    required String id,
    required String ticketId,
    required String userId,
    required String body,
    required DateTime createdAt,
    String? userName,
    String? userAvatarUrl,
  }) = _TicketComment;

  factory TicketComment.fromJson(Map<String, dynamic> json) => _$TicketCommentFromJson(json);
} 