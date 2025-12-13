import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/song_model.dart';
import 'package:myapp/services/song_service.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:myapp/providers/theme_provider.dart';
import 'package:myapp/widgets/song_post_card.dart'; // Import the new widget

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SongService _songService = SongService();
  final AuthService _authService = AuthService();
  late Stream<List<Song>> _songsStream;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _songsStream = _songService.getSongs();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kaekae Songbook'),
        actions: [
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.dark
                ? Icons.light_mode
                : Icons.dark_mode),
            onPressed: () => themeProvider.toggleTheme(),
            tooltip: 'Toggle Theme',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final router = GoRouter.of(context);
              await _authService.signOut();
              if (mounted) {
                router.go('/');
              }
            },
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _onSearchChanged,
              decoration: const InputDecoration(
                hintText: 'Search for songs, artists, or creators...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Song>>(
              stream: _songsStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                List<Song> songs = snapshot.data ?? [];
                if (_searchQuery.isNotEmpty) {
                  songs = songs
                      .where((song) =>
                          song.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                          song.artist.toLowerCase().contains(_searchQuery.toLowerCase()))
                      .toList();
                }

                return ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    return SongPostCard(song: songs[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/add-song'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
