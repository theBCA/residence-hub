import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'features/auth/view/login_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      return const MyApp();
    } else {
      return const LoginPage();
    }
  }
}

class MyRootApp extends StatelessWidget {
  const MyRootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthGate();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://vequxwdeoettksvaeybu.supabase.co',
    anonKey:'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZlcXV4d2Rlb2V0dGtzdmFleWJ1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI4Mjg5NjEsImV4cCI6MjA2ODQwNDk2MX0.tBOlg6XJ1ka_MCL7PCbst5JcJYdgKeFiu5mRHv1uIQg',
  );
  runApp(
    const ProviderScope(
      child: MyRootApp(),
    ),
  );
} 