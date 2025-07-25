import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/proposal.dart';
import '../viewmodel/proposal_viewmodel.dart';

class ProposalDetailPage extends ConsumerStatefulWidget {
  final String proposalId;
  
  const ProposalDetailPage({super.key, required this.proposalId});

  @override
  ConsumerState<ProposalDetailPage> createState() => _ProposalDetailPageState();
}

class _ProposalDetailPageState extends ConsumerState<ProposalDetailPage> {
  String? selectedChoice;

  @override
  Widget build(BuildContext context) {
    final proposalAsync = ref.watch(proposalDetailProvider(widget.proposalId));
    final resultsAsync = ref.watch(proposalResultsProvider(widget.proposalId));
    final userId = Supabase.instance.client.auth.currentUser?.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Proposal Details'),
      ),
      body: proposalAsync.when(
        data: (proposal) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Proposal Header
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getStatusColor(proposal.status),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              proposal.status.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            proposal.createdAt.toLocal().toString().split(' ')[0],
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        proposal.question,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Voting Section (only if proposal is open)
              if (proposal.status == 'open') ...[
                Text(
                  'Cast Your Vote',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ...proposal.options.map((option) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: RadioListTile<String>(
                    title: Text(option),
                    value: option,
                    groupValue: selectedChoice,
                    onChanged: (value) {
                      setState(() {
                        selectedChoice = value;
                      });
                    },
                  ),
                )),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: selectedChoice != null && userId != null
                        ? () => _submitVote(proposal.id, userId!, selectedChoice!)
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Submit Vote'),
                  ),
                ),
                const SizedBox(height: 32),
              ],
              
              // Results Section
              Text(
                'Voting Results',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              resultsAsync.when(
                data: (results) => _buildResultsChart(context, proposal.options, results),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Error loading results: $e'),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildResultsChart(BuildContext context, List<String> options, Map<String, int> results) {
    final totalVotes = results.values.fold(0, (sum, votes) => sum + votes);
    
    if (totalVotes == 0) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No votes yet.'),
        ),
      );
    }

    return Column(
      children: options.map((option) {
        final votes = results[option] ?? 0;
                 final percentage = totalVotes > 0 ? (votes / totalVotes * 100).toDouble() : 0.0;
        
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        option,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Text(
                      '$votes votes (${percentage.toStringAsFixed(1)}%)',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                                 LinearProgressIndicator(
                   value: (percentage / 100).toDouble(),
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getProgressColor(percentage),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'open':
        return Colors.green;
      case 'closed':
        return Colors.orange;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Color _getProgressColor(double percentage) {
    if (percentage >= 50) return Colors.green;
    if (percentage >= 25) return Colors.orange;
    return Colors.red;
  }

  Future<void> _submitVote(String proposalId, String userId, String choice) async {
    try {
      await ref.read(proposalsProvider.notifier).vote(
        proposalId: proposalId,
        userId: userId,
        choice: choice,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vote submitted successfully!')),
        );
        // Refresh results
        ref.invalidate(proposalResultsProvider(proposalId));
        setState(() {
          selectedChoice = null;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting vote: $e')),
        );
      }
    }
  }
} 