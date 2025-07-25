import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();
  final _apartmentController = TextEditingController();
  final _phoneController = TextEditingController();
  final _roleController = TextEditingController();
  final _statusController = TextEditingController();
  bool _loading = true;
  String? _error;
  String? _memberSince;
  String? _lastLogin;
  String? _email;
  String? _avatarUrl;
  bool _notifications = true;
  String _language = 'English';
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _fetchOrCreateProfile();
  }

  Future<void> _fetchOrCreateProfile() async {
    setState(() { _loading = true; _error = null; });
    try {
      final user = Supabase.instance.client.auth.currentUser;
      _email = user?.email;
      _memberSince = user?.createdAt.toString().split('T').first ?? '';
      _lastLogin = user?.lastSignInAt?.toString().split('T').first ?? '';
      final resList = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', user?.id);
      Map<String, dynamic>? res;
      if (resList.isEmpty) {
        await Supabase.instance.client.from('profiles').insert({
          'id': user?.id,
          'name': '',
          'apartment_no': '',
          'phone': '',
          'role': 'resident', // fixed
          'status': 'active', // fixed
          'avatar_url': '',
          'notifications': true,
          'language': 'English',
          'dark_mode': false,
        });
        res = {
          'name': '',
          'apartment_no': '',
          'phone': '',
          'role': 'resident', // fixed
          'status': 'active', // fixed
          'avatar_url': '',
          'notifications': true,
          'language': 'English',
          'dark_mode': false,
        };
      } else {
        res = resList.first;
      }
      _nameController.text = res?['name'] ?? '';
      _apartmentController.text = res?['apartment_no'] ?? '';
      _phoneController.text = res?['phone'] ?? '';
      _roleController.text = res?['role'] ?? '';
      _statusController.text = res?['status'] ?? '';
      _avatarUrl = res?['avatar_url'] ?? '';
      _notifications = res?['notifications'] ?? true;
      _language = res?['language'] ?? 'English';
      _darkMode = res?['dark_mode'] ?? false;
    } catch (e) {
      _error = e.toString();
    } finally {
      setState(() { _loading = false; });
    }
  }

  Future<void> _saveProfile() async {
    setState(() { _loading = true; _error = null; });
    try {
      final user = Supabase.instance.client.auth.currentUser;
      await Supabase.instance.client.from('profiles').update({
        'name': _nameController.text,
        'apartment_no': _apartmentController.text,
        'phone': _phoneController.text,
        'avatar_url': _avatarUrl,
        'notifications': _notifications,
        'language': _language,
        'dark_mode': _darkMode,
      }).eq('id', user?.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated.')));
      }
      await _fetchOrCreateProfile();
    } catch (e) {
      if (mounted) {
        setState(() { _error = e.toString(); });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_error!)));
      }
    } finally {
      setState(() { _loading = false; });
    }
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final user = Supabase.instance.client.auth.currentUser;
      final file = File(picked.path);
      final fileName = 'avatar_${user?.id}_${DateTime.now().millisecondsSinceEpoch}.png';
      final storageResponse = await Supabase.instance.client.storage.from('avatars').upload(fileName, file);
      if (storageResponse.isNotEmpty) {
        final url = Supabase.instance.client.storage.from('avatars').getPublicUrl(fileName);
        setState(() => _avatarUrl = url);
        await _saveProfile();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Avatar upload failed.')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                        backgroundImage: _avatarUrl != null && _avatarUrl!.isNotEmpty ? NetworkImage(_avatarUrl!) : null,
                        child: _avatarUrl == null || _avatarUrl!.isEmpty
                            ? Icon(Icons.person, size: 48, color: theme.colorScheme.primary)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickAvatar,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: theme.colorScheme.primary,
                            child: const Icon(Icons.edit, size: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Column(
                    children: [
                      Text(_nameController.text, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(_email ?? '', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.home_outlined),
                        title: const Text('Apartment'),
                        subtitle: Text(_apartmentController.text),
                      ),
                      ListTile(
                        leading: const Icon(Icons.phone_outlined),
                        title: const Text('Phone'),
                        subtitle: Text(_phoneController.text),
                      ),
                      ListTile(
                        leading: const Icon(Icons.verified_user_outlined),
                        title: const Text('Role'),
                        subtitle: Text(_roleController.text.isNotEmpty ? _roleController.text : 'resident'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.verified_outlined),
                        title: const Text('Status'),
                        subtitle: Text(_statusController.text.isNotEmpty ? _statusController.text : 'active'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.calendar_today_outlined),
                        title: const Text('Member since'),
                        subtitle: Text(_memberSince ?? ''),
                      ),
                      ListTile(
                        leading: const Icon(Icons.access_time_outlined),
                        title: const Text('Last login'),
                        subtitle: Text(_lastLogin ?? ''),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      SwitchListTile(
                        value: _notifications,
                        onChanged: (v) => setState(() => _notifications = v),
                        title: const Text('Notifications'),
                        secondary: const Icon(Icons.notifications_outlined),
                      ),
                      ListTile(
                        leading: const Icon(Icons.language_outlined),
                        title: const Text('Language'),
                        trailing: DropdownButton<String>(
                          value: _language,
                          items: const [
                            DropdownMenuItem(value: 'English', child: Text('English')),
                            DropdownMenuItem(value: 'Turkish', child: Text('Turkish')),
                            DropdownMenuItem(value: 'Russian', child: Text('Russian')),
                          ],
                          onChanged: (v) => setState(() => _language = v ?? 'English'),
                        ),
                      ),
                      SwitchListTile(
                        value: _darkMode,
                        onChanged: (v) => setState(() => _darkMode = v),
                        title: const Text('Dark Mode'),
                        secondary: const Icon(Icons.dark_mode_outlined),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _loading ? null : _saveProfile,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _loading ? const CircularProgressIndicator() : const Text('Save'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  onPressed: () async {
                    await Supabase.instance.client.auth.signOut();
                    if (context.mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(_error!, style: const TextStyle(color: Colors.red)),
                  ),
              ],
            ),
    );
  }
} 