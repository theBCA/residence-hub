import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/announcement.dart';

class AnnouncementDetailPage extends StatelessWidget {
  final Announcement announcement;
  const AnnouncementDetailPage({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Announcement')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (announcement.imageUrl != null && announcement.imageUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: announcement.imageUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 220,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  height: 220,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  height: 220,
                  child: const Icon(Icons.broken_image, size: 48),
                ),
              ),
            ),
          const SizedBox(height: 24),
          Text(announcement.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          Text(
            'Posted: ${announcement.createdAt.toLocal()}${(announcement.priority ?? '').isNotEmpty ? ' • ${announcement.priority}' : ''}',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: 24),
          Text(announcement.body, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
} 