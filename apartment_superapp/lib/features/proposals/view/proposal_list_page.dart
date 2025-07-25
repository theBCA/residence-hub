import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/proposal_viewmodel.dart';
import 'proposal_detail_page.dart';

class ProposalListPage extends ConsumerWidget {
  const ProposalListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proposalsAsync = ref.watch(proposalsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Proposals & Voting')),
      body: proposalsAsync.when(
        data: (proposals) => proposals.isEmpty
            ? const Center(child: Text('No proposals yet.'))
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: proposals.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final p = proposals[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: ListTile(
                      title: Text(p.question, style: Theme.of(context).textTheme.titleMedium),
                      subtitle: Text('Status: ${p.status} • Created: ${p.createdAt.toLocal().toString().split(" ")[0]}'),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ProposalDetailPage(proposalId: p.id),
                        ));
                      },
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateProposalDialog(context, ref),
        tooltip: 'Create Proposal',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateProposalDialog(BuildContext context, WidgetRef ref) {
    final questionController = TextEditingController();
    final optionControllers = [TextEditingController(), TextEditingController()];
    final formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Proposal'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: questionController,
                  decoration: const InputDecoration(labelText: 'Question'),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Enter a question' : null,
                ),
                const SizedBox(height: 16),
                ...List.generate(optionControllers.length, (i) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: optionControllers[i],
                          decoration: InputDecoration(labelText: 'Option ${i + 1}'),
                          validator: (v) => v == null || v.trim().isEmpty ? 'Enter an option' : null,
                        ),
                      ),
                      if (optionControllers.length > 2)
                        IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () {
                            optionControllers.removeAt(i);
                            (context as Element).markNeedsBuild();
                          },
                        ),
                    ],
                  ),
                )),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add Option'),
                    onPressed: () {
                      optionControllers.add(TextEditingController());
                      (context as Element).markNeedsBuild();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              final question = questionController.text.trim();
              final options = optionControllers.map((c) => c.text.trim()).where((o) => o.isNotEmpty).toList();
              if (options.length < 2) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter at least 2 options.')));
                return;
              }
              try {
                await ref.read(proposalsProvider.notifier).createProposal(question: question, options: options);
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Proposal created.')));
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
} 