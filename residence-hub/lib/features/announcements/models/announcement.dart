import 'package:freezed_annotation/freezed_annotation.dart';

part 'announcement.freezed.dart';
part 'announcement.g.dart';

@freezed
class Announcement with _$Announcement {
  const factory Announcement({
    required String id,
    required String title,
    required String body,
    String? imageUrl,
    String? priority,
    required DateTime createdAt,
  }) = _Announcement;

  factory Announcement.fromJson(Map<String, dynamic> json) => _$AnnouncementFromJson(json);
} 