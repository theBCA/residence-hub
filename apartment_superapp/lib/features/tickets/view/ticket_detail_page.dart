import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ticket.dart';
import '../viewmodel/ticket_list_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';

class TicketDetailPage extends ConsumerWidget {
  final Ticket ticket;
  final bool isOwner;
  const TicketDetailPage({super.key, required this.ticket, required this.isOwner});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ticket Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(ticket.title, style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      Text('Status: ${ticket.status ?? ''}', style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 8),
                      if ((ticket.category ?? '').isNotEmpty)
                        Text('Category: ${ticket.category ?? ''}', style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 8),
                      if ((ticket.description ?? '').isNotEmpty)
                        Text(ticket.description ?? '', style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 16),
                      Text('Created: ${ticket.createdAt.toLocal()}'),
                      const SizedBox(height: 16),
                      if ((ticket.attachmentUrl ?? '').isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Attachment:', style: Theme.of(context).textTheme.labelLarge),
                            const SizedBox(height: 8),
                            if ((ticket.attachmentUrl ?? '').endsWith('.png') || (ticket.attachmentUrl ?? '').endsWith('.jpg') || (ticket.attachmentUrl ?? '').endsWith('.jpeg') || (ticket.attachmentUrl ?? '').endsWith('.gif'))
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(ticket.attachmentUrl ?? '', height: 180, fit: BoxFit.cover),
                              )
                            else
                              InkWell(
                                onTap: () => launchUrl(Uri.parse(ticket.attachmentUrl ?? '')),
                                child: Row(
                                  children: [
                                    const Icon(Icons.attach_file),
                                    const SizedBox(width: 8),
                                    Flexible(child: Text(ticket.attachmentUrl ?? '', overflow: TextOverflow.ellipsis)),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      const SizedBox(height: 8),
                      if (isOwner) ...[
                        Row(
                          children: [
                            ElevatedButton.icon(
                              icon: const Icon(Icons.edit),
                              label: const Text('Edit'),
                              onPressed: () => _showEditDialog(context, ref),
                            ),
                            const SizedBox(width: 16),
                            OutlinedButton.icon(
                              icon: const Icon(Icons.delete),
                              label: const Text('Delete'),
                              onPressed: () => _showDeleteDialog(context, ref),
                              style: OutlinedButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController(text: ticket.title);
    final descController = TextEditingController(text: ticket.description ?? '');
    final categoryController = TextEditingController(text: ticket.category ?? '');
    String? status = ticket.status;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Ticket'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                DropdownButtonFormField<String>(
                  value: status,
                  items: const [
                    DropdownMenuItem(value: 'open', child: Text('Open')),
                    DropdownMenuItem(value: 'in_progress', child: Text('In Progress')),
                    DropdownMenuItem(value: 'resolved', child: Text('Resolved')),
                  ],
                  onChanged: (val) => status = val ?? 'open',
                  decoration: const InputDecoration(labelText: 'Status'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await ref.read(ticketListViewModelProvider.notifier).updateTicket(
                  id: ticket.id,
                  title: titleController.text,
                  description: descController.text,
                  category: categoryController.text,
                  status: status,
                );
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ticket updated.')));
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Ticket'),
        content: const Text('Are you sure you want to delete this ticket?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.onError, backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () async {
              await ref.read(ticketListViewModelProvider.notifier).deleteTicket(ticket.id);
              if (context.mounted) {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ticket deleted.')));
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
} 