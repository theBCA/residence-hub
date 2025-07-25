import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../viewmodel/ticket_list_viewmodel.dart';
import 'ticket_detail_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

final ticketSearchProvider = StateProvider<String>((ref) => '');
final ticketStatusFilterProvider = StateProvider<String>((ref) => 'All');
final ticketCategoryFilterProvider = StateProvider<String>((ref) => 'All');
final ticketSortProvider = StateProvider<String>((ref) => 'Date');

class TicketListView extends ConsumerWidget {
  const TicketListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticketsAsync = ref.watch(ticketListViewModelProvider);
    final userId = Supabase.instance.client.auth.currentUser?.id;
    final search = ref.watch(ticketSearchProvider);
    final statusFilter = ref.watch(ticketStatusFilterProvider);
    final categoryFilter = ref.watch(ticketCategoryFilterProvider);
    final sort = ref.watch(ticketSortProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Tickets')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search tickets...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => ref.read(ticketSearchProvider.notifier).state = value,
                ),
                const SizedBox(height: 12),
                // Status filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...['All', 'open', 'in_progress', 'resolved'].map((status) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(status == 'All' ? 'All' : _statusLabel(status)),
                          selected: statusFilter == status,
                          onSelected: (selected) {
                            if (selected) {
                              ref.read(ticketStatusFilterProvider.notifier).state = status;
                            }
                          },
                        ),
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Category and Sort filters
                Row(
                  children: [
                    Text('Filters:', style: Theme.of(context).textTheme.labelMedium),
                    const SizedBox(width: 12),
                    PopupMenuButton<String>(
                      initialValue: categoryFilter,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(categoryFilter, style: const TextStyle(fontSize: 14)),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_drop_down, size: 16),
                          ],
                        ),
                      ),
                      itemBuilder: (context) => ['All', 'General', 'Maintenance', 'Finance', 'Other']
                          .map((cat) => PopupMenuItem(
                                value: cat,
                                child: Text(cat),
                              ))
                          .toList(),
                      onSelected: (val) => ref.read(ticketCategoryFilterProvider.notifier).state = val,
                    ),
                    const SizedBox(width: 12),
                    PopupMenuButton<String>(
                      initialValue: sort,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Sort: $sort', style: const TextStyle(fontSize: 14)),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_drop_down, size: 16),
                          ],
                        ),
                      ),
                      itemBuilder: (context) => ['Date', 'Status', 'Category']
                          .map((s) => PopupMenuItem(
                                value: s,
                                child: Text(s),
                              ))
                          .toList(),
                      onSelected: (val) => ref.read(ticketSortProvider.notifier).state = val,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ticketsAsync.when(
              data: (tickets) {
                // Debug: print tickets with null status or category
                for (final t in tickets) {
                  if (t.status == null || t.category == null) {
                    // ignore: avoid_print
                    print('DEBUG: Ticket with null status or category: id=${t.id}, status=${t.status}, category=${t.category}');
                  }
                }
                // Apply search, filter, sort in memory
                var filtered = tickets.where((t) {
                  final status = t.status ?? '';
                  final category = t.category ?? '';
                  final matchesSearch = search.isEmpty ||
                      t.title.toLowerCase().contains(search.toLowerCase()) ||
                      (t.description ?? '').toLowerCase().contains(search.toLowerCase());
                  final matchesStatus = statusFilter == 'All' || status == statusFilter;
                  final matchesCategory = categoryFilter == 'All' || category == categoryFilter;
                  return matchesSearch && matchesStatus && matchesCategory;
                }).toList();
                if (sort == 'Date') {
                  filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
                } else if (sort == 'Status') {
                  filtered.sort((a, b) => (a.status ?? '').compareTo(b.status ?? ''));
                } else if (sort == 'Category') {
                  filtered.sort((a, b) => (a.category ?? '').compareTo(b.category ?? ''));
                }
                if (filtered.isEmpty) {
                  return const Center(child: Text('No tickets found.'));
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    final ticket = filtered[index];
                    final isOwner = userId != null && ticket.createdBy == userId;
                    return RepaintBoundary(
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => TicketDetailPage(ticket: ticket, isOwner: isOwner),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                  child: Icon(Icons.confirmation_number, color: Theme.of(context).colorScheme.primary),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          if ((ticket.category ?? '').isNotEmpty)
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                              margin: const EdgeInsets.only(right: 8),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.15),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                (ticket.category ?? ''),
                                                style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: _statusColor(context, ticket.status ?? '').withValues(alpha: 0.15),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(_statusIcon(ticket.status ?? ''), size: 14, color: _statusColor(context, ticket.status ?? '')),
                                                const SizedBox(width: 4),
                                                Text(
                                                  (ticket.status ?? '').isNotEmpty ? _statusLabel(ticket.status ?? '') : '',
                                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                                          Text(
                        ticket.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                                    const SizedBox(height: 8),
                                                          if ((ticket.description ?? '').isNotEmpty)
                        Text(
                          (ticket.description?.length ?? 0) > 100 ? '${ticket.description!.substring(0, 100)}...' : (ticket.description ?? ''),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                        ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Icon(Icons.calendar_today, size: 16, color: Colors.grey[500]),
                                        const SizedBox(width: 4),
                                        Text(
                                          ticket.createdAt.toLocal().toString().split(" ")[0],
                                          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey[500]),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ));
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateTicketDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Color _statusColor(BuildContext context, String status) {
    switch (status) {
      case 'open':
        return Theme.of(context).colorScheme.primary;
      case 'in_progress':
        return Colors.orange;
      case 'resolved':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'open':
        return Icons.radio_button_unchecked;
      case 'in_progress':
        return Icons.timelapse;
      case 'resolved':
        return Icons.check_circle;
      default:
        return Icons.help_outline;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'open':
        return 'Open';
      case 'in_progress':
        return 'In Progress';
      case 'resolved':
        return 'Resolved';
      case 'All':
        return 'All';
      default:
        return status;
    }
  }

  void _showCreateTicketDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    String selectedCategory = 'General';
    File? attachmentFile;
    String? attachmentPreviewPath;
    final picker = ImagePicker();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              boxShadow: const [BoxShadow(blurRadius: 24, color: Colors.black12)],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    child: Icon(Icons.confirmation_number, size: 36, color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(height: 16),
                  Text('Create Ticket', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 24),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Category', style: Theme.of(context).textTheme.labelLarge),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['General', 'Maintenance', 'Finance', 'Other']
                        .map((cat) => ChoiceChip(
                              label: Text(cat),
                              selected: selectedCategory == cat,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() => selectedCategory = cat);
                                }
                              },
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  if (attachmentPreviewPath != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(File(attachmentPreviewPath!), height: 120, fit: BoxFit.cover),
                    ),
                  TextButton.icon(
                    icon: const Icon(Icons.attach_file),
                    label: const Text('Attach Image'),
                    onPressed: () async {
                      final picked = await picker.pickImage(source: ImageSource.gallery);
                      if (picked != null) {
                        setState(() {
                          attachmentFile = File(picked.path);
                          attachmentPreviewPath = picked.path;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 2,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        ),
                        onPressed: () async {
                          if (titleController.text.trim().isEmpty || selectedCategory.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Title and category are required.')));
                            return;
                          }
                          String? attachmentUrl;
                          try {
                            if (attachmentFile != null) {
                              final fileName = 'ticket_${DateTime.now().millisecondsSinceEpoch}_${attachmentFile!.path.split('/').last}';
                              final storage = Supabase.instance.client.storage;
                              final res = await storage.from('ticket-attachments').upload(fileName, attachmentFile!);
                              if (res.isNotEmpty) {
                                final url = storage.from('ticket-attachments').getPublicUrl(fileName);
                                attachmentUrl = url;
                              }
                            }
                            await ref.read(ticketListViewModelProvider.notifier).createTicket(
                              title: titleController.text,
                              description: descController.text,
                              category: selectedCategory,
                              attachmentUrl: attachmentUrl,
                            );
                            if (context.mounted) {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ticket created.')));
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 