import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'features/home/view/home_page.dart';
import 'features/auth/view/login_page.dart';
import 'features/tickets/ticket_list_page.dart';
import 'features/profile/view/profile_completion_page.dart';
import 'features/auth/view/password_reset_page.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = Supabase.instance.client.auth.currentUser;
    
    // Listen to auth state changes
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (mounted) {
        setState(() {
          _user = data.session?.user;
        });
      }
    });
  }

  // Add a helper function to check profile completeness
  Future<bool> isProfileComplete() async {
    if (_user == null) return false;
    try {
      final res = await Supabase.instance.client
          .from('profiles')
          .select('name, phone, apartment_no')
          .eq('id', _user!.id)
          .single();
      return (res['name']?.toString().trim().isNotEmpty ?? false) &&
             (res['phone']?.toString().trim().isNotEmpty ?? false) &&
             (res['apartment_no']?.toString().trim().isNotEmpty ?? false);
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // If no user, show login page
    if (_user == null) {
      return const LoginPage();
    }
    
    // If user exists, check profile completeness
    return FutureBuilder<bool>(
      future: isProfileComplete(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.data == false) {
          return const ProfileCompletionPage();
        }
        return const HomePage();
      },
    );
  }
}

class MyRootApp extends StatelessWidget {
  const MyRootApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const AuthGate(),
        ),
        GoRoute(
          path: '/reset-password',
          builder: (context, state) => const PasswordResetPage(),
        ),
        GoRoute(
          path: '/tickets',
          builder: (context, state) => const TicketListPage(),
        ),
        GoRoute(
          path: '/proposals',
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Proposals (Coming Soon)')),
          ),
        ),
        GoRoute(
          path: '/ledger',
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Ledger (Coming Soon)')),
          ),
        ),
        GoRoute(
          path: '/announcements',
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Announcements (Coming Soon)')),
          ),
        ),
      ],
    );

    // Monochrome ColorSchemes
    const lightColorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: Colors.black,
      onPrimary: Colors.white,
      secondary: Colors.black,
      onSecondary: Colors.white,
      error: Colors.black,
      onError: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black,
    );
    
    const darkColorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.white,
      onPrimary: Colors.black,
      secondary: Colors.white,
      onSecondary: Colors.black,
      error: Colors.white,
      onError: Colors.black,
      surface: Colors.black,
      onSurface: Colors.white,
    );

    return MaterialApp.router(
      title: 'ResidenceHub',
      routerConfig: router,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
      ),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling,
          ),
          child: child!,
        );
      },
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: '',
    anonKey:'',
  );
  runApp(
    const ProviderScope(
      child: MyRootApp(),
    ),
  );
} 
