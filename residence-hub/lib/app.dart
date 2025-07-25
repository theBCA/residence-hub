import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/home/view/home_page.dart';
import 'features/auth/login_page.dart';
import 'features/tickets/ticket_list_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features/profile/view/profile_completion_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Add a helper function to check profile completeness
  Future<bool> isProfileComplete() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return false;
    final res = await Supabase.instance.client.from('profiles').select('name, phone, apartment_no').eq('id', user.id).single();
    return (res['name']?.toString().trim().isNotEmpty ?? false) &&
           (res['phone']?.toString().trim().isNotEmpty ?? false) &&
           (res['apartment_no']?.toString().trim().isNotEmpty ?? false);
  }

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => FutureBuilder<bool>(
            future: isProfileComplete(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              }
              if (snapshot.data == false) {
                return const ProfileCompletionPage();
              }
              return const HomePage();
            },
          ),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/tickets',
          builder: (context, state) => const TicketListPage(),
        ),
        GoRoute(
          path: '/proposals',
          builder: (context, state) => const Scaffold(body: Center(child: Text('Proposals (Coming Soon)'))),
        ),
        GoRoute(
          path: '/ledger',
          builder: (context, state) => const Scaffold(body: Center(child: Text('Ledger (Coming Soon)'))),
        ),
        GoRoute(
          path: '/announcements',
          builder: (context, state) => const Scaffold(body: Center(child: Text('Announcements (Coming Soon)'))),
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
      // Add performance optimizations
      debugShowCheckedModeBanner: false,
      // Reduce animation duration for smoother navigation
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // Disable accessibility scaling for consistent performance
            textScaler: TextScaler.noScaling,
          ),
          child: child!,
        );
      },
    );
  }
} 