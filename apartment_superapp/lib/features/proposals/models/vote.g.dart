// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VoteImpl _$$VoteImplFromJson(Map<String, dynamic> json) => _$VoteImpl(
      id: json['id'] as String,
      proposalId: json['proposalId'] as String,
      userId: json['userId'] as String,
      choice: json['choice'] as String,
    );

Map<String, dynamic> _$$VoteImplToJson(_$VoteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'proposalId': instance.proposalId,
      'userId': instance.userId,
      'choice': instance.choice,
    };
