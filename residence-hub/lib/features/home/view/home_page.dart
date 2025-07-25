import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../tickets/view/ticket_list_view.dart';
import '../../announcements/view/announcement_list_view.dart';
import '../../announcements/viewmodel/announcement_list_viewmodel.dart';
import '../../ledger/view/ledger_page.dart';
import '../../proposals/view/proposal_list_page.dart';
import '../../profile/view/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Use IndexedStack for better performance - only builds visible page
  List<Widget> _buildPages() {
    return [
      _DashboardView(),
      const TicketListView(),
      const ProposalListPage(),
      const LedgerPage(),
      const AnnouncementListView(),
      const ProfilePage(),
    ];
  }

  void _navigateToPage(int pageIndex) {
    setState(() => _selectedIndex = pageIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.home_work,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'ResidenceHub',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _buildPages(),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.confirmation_number), label: 'Tickets'),
          NavigationDestination(icon: Icon(Icons.how_to_vote), label: 'Proposals'),
          NavigationDestination(icon: Icon(Icons.receipt_long), label: 'Ledger'),
          NavigationDestination(icon: Icon(Icons.campaign), label: 'Announcements'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class _DashboardView extends ConsumerStatefulWidget {
  @override
  ConsumerState<_DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<_DashboardView> {
  void _navigateToPage(int pageIndex) {
    // Get the parent HomePage state to change the page
    final homePageState = context.findAncestorStateOfType<_HomePageState>();
    homePageState?._navigateToPage(pageIndex);
  }

  Widget _buildLatestAnnouncement(BuildContext context, AsyncValue announcementsAsync) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      child: announcementsAsync.when(
        data: (announcements) {
          if (announcements.isEmpty) {
            return ListTile(
              leading: Icon(Icons.campaign, color: Colors.grey[600]),
              title: Text(
                'Latest Announcement',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              subtitle: Text(
                'No announcements yet.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            );
          }
          
          final latestAnnouncement = announcements.first;
          return ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.campaign, color: Colors.orange[600], size: 20),
            ),
            title: Text(
              latestAnnouncement.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  latestAnnouncement.body,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  latestAnnouncement.createdAt.toLocal().toString().split(' ')[0],
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[600]),
            onTap: () => _navigateToPage(4), // Navigate to announcements page
          );
        },
        loading: () => ListTile(
          leading: Icon(Icons.campaign, color: Colors.grey[600]),
          title: Text(
            'Latest Announcement',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          subtitle: const SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        error: (e, _) => ListTile(
          leading: Icon(Icons.campaign, color: Colors.grey[600]),
          title: Text(
            'Latest Announcement',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          subtitle: Text(
            'Error loading announcements',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.red[600],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildRecentActivity(BuildContext context) {
    // Sample recent activity data - in a real app, this would come from providers
    final activities = [
      {'type': 'ticket', 'title': 'New ticket created', 'subtitle': 'Maintenance request for elevator', 'time': '2 hours ago'},
      {'type': 'proposal', 'title': 'Voting closed', 'subtitle': 'Security camera proposal results', 'time': '1 day ago'},
      {'type': 'announcement', 'title': 'New announcement', 'subtitle': 'Building maintenance scheduled', 'time': '2 days ago'},
    ];

    if (activities.isEmpty) {
      return [
        const Card(
          child: ListTile(
            title: Text('No recent activity.'),
          ),
        ),
      ];
    }

    return activities.map((activity) => Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getActivityColor(activity['type'] as String),
          child: Icon(
            _getActivityIcon(activity['type'] as String),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(activity['title'] as String),
        subtitle: Text(activity['subtitle'] as String),
        trailing: Text(
          activity['time'] as String,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ),
    )).toList();
  }

  Color _getActivityColor(String type) {
    switch (type) {
      case 'ticket':
        return Colors.blue;
      case 'proposal':
        return Colors.purple;
      case 'announcement':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'ticket':
        return Icons.confirmation_number;
      case 'proposal':
        return Icons.how_to_vote;
      case 'announcement':
        return Icons.campaign;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    final announcementsAsync = ref.watch(announcementListViewModelProvider);
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Text('Welcome!', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildLatestAnnouncement(context, announcementsAsync),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _QuickActionButton(
                label: 'Tickets', 
                icon: Icons.confirmation_number,
                onPressed: () => _navigateToPage(1),
              ),
              _QuickActionButton(
                label: 'Proposals', 
                icon: Icons.how_to_vote,
                onPressed: () => _navigateToPage(2),
              ),
              _QuickActionButton(
                label: 'Ledger', 
                icon: Icons.receipt_long,
                onPressed: () => _navigateToPage(3),
              ),
              _QuickActionButton(
                label: 'Announcements', 
                icon: Icons.campaign,
                onPressed: () => _navigateToPage(4),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text('Recent Activity', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          ..._buildRecentActivity(context),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  const _QuickActionButton({required this.label, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: FilledButton.styleFrom(minimumSize: const Size(140, 48)),
    );
  }
} 