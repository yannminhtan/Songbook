
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/theme_provider.dart';
import 'package:myapp/screens/add_song_screen.dart';
import 'package:myapp/screens/song_detail_screen.dart';
import 'package:myapp/models/song_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kaekae Songbook'),
        actions: [
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeProvider.toggleTheme(),
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for songs, artists, ...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 20, // Placeholder for song list
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Song Title ${index + 1}'),
                  subtitle: Text('Artist Name'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SongDetailScreen(
                          song: Song(
                            id: index.toString(),
                            title: 'Song Title ${index + 1}',
                            artist: 'Artist Name',
                            content: 'This is a placeholder for the song content. [G] a chord. [C] another one.',
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
           Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddSongScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
