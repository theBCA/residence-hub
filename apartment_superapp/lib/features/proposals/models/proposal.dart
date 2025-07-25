import 'package:freezed_annotation/freezed_annotation.dart';

part 'proposal.freezed.dart';
part 'proposal.g.dart';

@freezed
class Proposal with _$Proposal {
  const factory Proposal({
    required String id,
    required String question,
    required List<String> options,
    required String status,
    required DateTime createdAt,
  }) = _Proposal;

  factory Proposal.fromJson(Map<String, dynamic> json) => _$ProposalFromJson(json);
} 