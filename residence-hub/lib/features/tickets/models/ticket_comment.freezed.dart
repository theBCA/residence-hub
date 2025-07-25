// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ticket_comment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TicketComment _$TicketCommentFromJson(Map<String, dynamic> json) {
  return _TicketComment.fromJson(json);
}

/// @nodoc
mixin _$TicketComment {
  String get id => throw _privateConstructorUsedError;
  String get ticketId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String? get userName => throw _privateConstructorUsedError;
  String? get userAvatarUrl => throw _privateConstructorUsedError;

  /// Serializes this TicketComment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TicketComment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TicketCommentCopyWith<TicketComment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TicketCommentCopyWith<$Res> {
  factory $TicketCommentCopyWith(
          TicketComment value, $Res Function(TicketComment) then) =
      _$TicketCommentCopyWithImpl<$Res, TicketComment>;
  @useResult
  $Res call(
      {String id,
      String ticketId,
      String userId,
      String body,
      DateTime createdAt,
      String? userName,
      String? userAvatarUrl});
}

/// @nodoc
class _$TicketCommentCopyWithImpl<$Res, $Val extends TicketComment>
    implements $TicketCommentCopyWith<$Res> {
  _$TicketCommentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TicketComment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ticketId = null,
    Object? userId = null,
    Object? body = null,
    Object? createdAt = null,
    Object? userName = freezed,
    Object? userAvatarUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ticketId: null == ticketId
          ? _value.ticketId
          : ticketId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      userAvatarUrl: freezed == userAvatarUrl
          ? _value.userAvatarUrl
          : userAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TicketCommentImplCopyWith<$Res>
    implements $TicketCommentCopyWith<$Res> {
  factory _$$TicketCommentImplCopyWith(
          _$TicketCommentImpl value, $Res Function(_$TicketCommentImpl) then) =
      __$$TicketCommentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String ticketId,
      String userId,
      String body,
      DateTime createdAt,
      String? userName,
      String? userAvatarUrl});
}

/// @nodoc
class __$$TicketCommentImplCopyWithImpl<$Res>
    extends _$TicketCommentCopyWithImpl<$Res, _$TicketCommentImpl>
    implements _$$TicketCommentImplCopyWith<$Res> {
  __$$TicketCommentImplCopyWithImpl(
      _$TicketCommentImpl _value, $Res Function(_$TicketCommentImpl) _then)
      : super(_value, _then);

  /// Create a copy of TicketComment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ticketId = null,
    Object? userId = null,
    Object? body = null,
    Object? createdAt = null,
    Object? userName = freezed,
    Object? userAvatarUrl = freezed,
  }) {
    return _then(_$TicketCommentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ticketId: null == ticketId
          ? _value.ticketId
          : ticketId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      userAvatarUrl: freezed == userAvatarUrl
          ? _value.userAvatarUrl
          : userAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TicketCommentImpl implements _TicketComment {
  const _$TicketCommentImpl(
      {required this.id,
      required this.ticketId,
      required this.userId,
      required this.body,
      required this.createdAt,
      this.userName,
      this.userAvatarUrl});

  factory _$TicketCommentImpl.fromJson(Map<String, dynamic> json) =>
      _$$TicketCommentImplFromJson(json);

  @override
  final String id;
  @override
  final String ticketId;
  @override
  final String userId;
  @override
  final String body;
  @override
  final DateTime createdAt;
  @override
  final String? userName;
  @override
  final String? userAvatarUrl;

  @override
  String toString() {
    return 'TicketComment(id: $id, ticketId: $ticketId, userId: $userId, body: $body, createdAt: $createdAt, userName: $userName, userAvatarUrl: $userAvatarUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TicketCommentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ticketId, ticketId) ||
                other.ticketId == ticketId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userAvatarUrl, userAvatarUrl) ||
                other.userAvatarUrl == userAvatarUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, ticketId, userId, body,
      createdAt, userName, userAvatarUrl);

  /// Create a copy of TicketComment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TicketCommentImplCopyWith<_$TicketCommentImpl> get copyWith =>
      __$$TicketCommentImplCopyWithImpl<_$TicketCommentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TicketCommentImplToJson(
      this,
    );
  }
}

abstract class _TicketComment implements TicketComment {
  const factory _TicketComment(
      {required final String id,
      required final String ticketId,
      required final String userId,
      required final String body,
      required final DateTime createdAt,
      final String? userName,
      final String? userAvatarUrl}) = _$TicketCommentImpl;

  factory _TicketComment.fromJson(Map<String, dynamic> json) =
      _$TicketCommentImpl.fromJson;

  @override
  String get id;
  @override
  String get ticketId;
  @override
  String get userId;
  @override
  String get body;
  @override
  DateTime get createdAt;
  @override
  String? get userName;
  @override
  String? get userAvatarUrl;

  /// Create a copy of TicketComment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TicketCommentImplCopyWith<_$TicketCommentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
