import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/firebase_options.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:myapp/screens/welcome_screen.dart';
import 'package:myapp/screens/home_screen.dart';
import 'package:myapp/screens/song_detail_screen.dart';
import 'package:myapp/screens/add_song_screen.dart';
import 'package:myapp/screens/edit_song_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => authService.authStateChanges.isBroadcast 
              ? const HomeScreen() 
              : const WelcomeScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/song/:id',
          builder: (context, state) => SongDetailScreen(
            songId: state.pathParameters['id']!,
          ),
        ),
        GoRoute(
          path: '/add-song',
          builder: (context, state) => const AddSongScreen(),
        ),
        GoRoute(
          path: '/edit-song/:id',
          builder: (context, state) => EditSongScreen(
            songId: state.pathParameters['id']!,
          ),
        ),
      ],
    );

    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            title: 'Kaekae Songbook',
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.blue,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.blue,
            ),
            themeMode: themeProvider.themeMode,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
