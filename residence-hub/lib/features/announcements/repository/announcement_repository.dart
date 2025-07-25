import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/announcement.dart';
import 'dart:io';

class AnnouncementRepository {
  final _client = Supabase.instance.client;

  Future<List<Announcement>> fetchAnnouncements() async {
    try {
      final response = await _client
          .from('announcements')
          .select()
          .order('created_at', ascending: false);
      return (response as List)
        .map((json) {
          final map = Map<String, dynamic>.from(json as Map);
          // Map database field names to model field names safely
          return Announcement.fromJson({
            'id': map['id'] ?? '',
            'title': map['title'] ?? '',
            'body': map['body'] ?? '',
            'imageUrl': map.containsKey('image_url') ? (map['image_url'] ?? '') : '',
            'priority': map['priority'] ?? '',
            'createdAt': map['created_at'] ?? DateTime.now().toIso8601String(),
          });
        })
        .toList();
    } catch (e) {
      // Return empty list if there's a database/permission issue
      print('Error fetching announcements: $e');
      return [];
    }
  }

  Future<void> createAnnouncement({
    required String title,
    required String body,
    String? priority,
    File? imageFile,
  }) async {
    String? imageUrl;
    if (imageFile != null) {
      final fileName = 'announcement_${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
      final storageResponse = await _client.storage.from('announcements').upload(fileName, imageFile);
      if (storageResponse.isEmpty) {
        throw Exception('Image upload failed');
      }
      imageUrl = _client.storage.from('announcements').getPublicUrl(fileName);
    }
    final insertData = {
      'title': title,
      'body': body,
      'priority': priority,
      'created_at': DateTime.now().toIso8601String(),
    };
    
    // Only add image_url if we have one (for future database compatibility)
    if (imageUrl != null) {
      insertData['image_url'] = imageUrl;
    }
    
    await _client.from('announcements').insert(insertData);
  }
} 