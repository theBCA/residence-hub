import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ticket.dart';
import '../repository/ticket_repository.dart';

final ticketRepositoryProvider = Provider<TicketRepository>((ref) => TicketRepository());
final ticketListViewModelProvider = AsyncNotifierProvider<TicketListViewModel, List<Ticket>>(TicketListViewModel.new);

class TicketListViewModel extends AsyncNotifier<List<Ticket>> {
  late final TicketRepository _repository;

  @override
  Future<List<Ticket>> build() async {
    _repository = ref.read(ticketRepositoryProvider);
    return await _repository.fetchTickets();
  }

  Future<void> createTicket({
    required String title,
    String? description,
    String? category,
    String? attachmentUrl,
  }) async {
    await _repository.createTicket(
      title: title,
      description: description,
      category: category,
      attachmentUrl: attachmentUrl,
    );
    state = const AsyncLoading();
    state = AsyncData(await _repository.fetchTickets());
  }

  Future<void> updateTicket({
    required String id,
    required String title,
    String? description,
    String? category,
    String? status,
  }) async {
    await _repository.updateTicket(
      id: id,
      title: title,
      description: description,
      category: category,
      status: status,
    );
    state = const AsyncLoading();
    state = AsyncData(await _repository.fetchTickets());
  }

  Future<void> deleteTicket(String id) async {
    await _repository.deleteTicket(id);
    state = const AsyncLoading();
    state = AsyncData(await _repository.fetchTickets());
  }
} 