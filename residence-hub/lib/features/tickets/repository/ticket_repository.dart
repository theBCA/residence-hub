import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/ticket.dart';

class TicketRepository {
  final _client = Supabase.instance.client;

  Future<List<Ticket>> fetchTickets() async {
    final response = await _client
        .from('tickets')
        .select()
        .order('created_at', ascending: false);
    return (response as List)
        .map((json) {
          final map = Map<String, dynamic>.from(json as Map);
          // Map database field names to model field names
          return Ticket.fromJson({
            'id': map['id'] ?? '',
            'title': map['title'] ?? '',
            'createdBy': map['created_by'] ?? '',
            'description': map['description'] ?? '',
            'category': map['category'] ?? '',
            'status': map['status'] ?? '',
            'attachmentUrl': map['attachment_url'] ?? '',
            'createdAt': map['created_at'] ?? DateTime.now().toIso8601String(),
          });
        })
        .toList();
  }

  Future<void> createTicket({
    required String title,
    String? description,
    String? category,
    String? attachmentUrl,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Not authenticated');
    await _client.from('tickets').insert({
      'created_by': userId,
      'title': title,
      'description': description ?? '',
      'category': category ?? '',
      'status': 'open',
      'created_at': DateTime.now().toIso8601String(),
      if (attachmentUrl != null) 'attachment_url': attachmentUrl,
    });
  }

  Future<void> updateTicket({
    required String id,
    required String title,
    String? description,
    String? category,
    String? status,
  }) async {
    await _client.from('tickets').update({
      'title': title,
      'description': description ?? '',
      'category': category ?? '',
      'status': status ?? '',
    }).eq('id', id);
  }

  Future<void> deleteTicket(String id) async {
    await _client.from('tickets').delete().eq('id', id);
  }
} 