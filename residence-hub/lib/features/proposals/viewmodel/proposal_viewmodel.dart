import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/proposal.dart';
import '../repository/proposal_repository.dart';

final proposalRepositoryProvider = Provider<ProposalRepository>((ref) => ProposalRepository());

final proposalsProvider = AsyncNotifierProvider<ProposalViewModel, List<Proposal>>(ProposalViewModel.new);
final proposalDetailProvider = FutureProvider.family<Proposal, String>((ref, id) async {
  final repo = ref.read(proposalRepositoryProvider);
  final proposals = await repo.fetchProposals();
  return proposals.firstWhere((p) => p.id == id);
});
final proposalResultsProvider = FutureProvider.family<Map<String, int>, String>((ref, proposalId) async {
  final repo = ref.read(proposalRepositoryProvider);
  return repo.fetchResults(proposalId);
});

class ProposalViewModel extends AsyncNotifier<List<Proposal>> {
  late final ProposalRepository _repository;

  @override
  Future<List<Proposal>> build() async {
    _repository = ref.read(proposalRepositoryProvider);
    return await _repository.fetchProposals();
  }

  Future<void> createProposal({
    required String question,
    required List<String> options,
  }) async {
    await _repository.createProposal(question: question, options: options);
    state = const AsyncLoading();
    state = AsyncData(await _repository.fetchProposals());
  }

  Future<void> vote({
    required String proposalId,
    required String userId,
    required String choice,
  }) async {
    await _repository.vote(proposalId: proposalId, userId: userId, choice: choice);
    // Optionally refresh proposals or results if needed
  }
} 