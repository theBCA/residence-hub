import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/announcement.dart';
import '../repository/announcement_repository.dart';
import 'dart:io';

final announcementRepositoryProvider = Provider<AnnouncementRepository>((ref) => AnnouncementRepository());

final announcementListViewModelProvider =
    AsyncNotifierProvider<AnnouncementListViewModel, List<Announcement>>(AnnouncementListViewModel.new);

class AnnouncementListViewModel extends AsyncNotifier<List<Announcement>> {
  late final AnnouncementRepository _repository;

  @override
  Future<List<Announcement>> build() async {
    _repository = ref.read(announcementRepositoryProvider);
    return await _repository.fetchAnnouncements();
  }

  Future<void> createAnnouncement({
    required String title,
    required String body,
    String? priority,
    File? imageFile,
  }) async {
    try {
      await _repository.createAnnouncement(
        title: title,
        body: body,
        priority: priority,
        imageFile: imageFile,
      );
      state = const AsyncLoading();
      state = AsyncData(await _repository.fetchAnnouncements());
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
} 