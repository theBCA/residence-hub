import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/proposal.dart';

class ProposalRepository {
  final _client = Supabase.instance.client;

  Future<List<Proposal>> fetchProposals() async {
    try {
      final response = await _client
          .from('proposals')
          .select()
          .order('created_at', ascending: false);
      return (response as List)
          .map((json) {
            final map = Map<String, dynamic>.from(json as Map);
            // Map database field names to model field names safely
            return Proposal.fromJson({
              'id': map['id'] ?? '',
              'question': map['question'] ?? '',
              'options': map['options'] ?? <String>[],
              'status': map['status'] ?? 'open',
              'createdAt': map['created_at'] ?? DateTime.now().toIso8601String(),
            });
          })
          .toList();
    } catch (e) {
      // Return empty list if there's a database/permission issue
      print('Error fetching proposals: $e');
      return [];
    }
  }

  Future<void> createProposal({
    required String question,
    required List<String> options,
  }) async {
    await _client.from('proposals').insert({
      'question': question,
      'options': options,
      'status': 'open',
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> vote({
    required String proposalId,
    required String userId,
    required String choice,
  }) async {
    // Upsert: one vote per user per proposal
    await _client.from('votes').upsert({
      'proposal_id': proposalId,
      'user_id': userId,
      'choice': choice,
    }, onConflict: 'proposal_id, user_id');
  }

  Future<Map<String, int>> fetchResults(String proposalId) async {
    final response = await _client
        .from('votes')
        .select('choice')
        .eq('proposal_id', proposalId);
    final counts = <String, int>{};
    for (final row in response as List) {
      final choice = row['choice'] as String;
      counts[choice] = (counts[choice] ?? 0) + 1;
    }
    return counts;
  }
} 