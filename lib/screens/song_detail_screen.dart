import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/models/song_model.dart';
import 'package:myapp/services/song_service.dart';
import 'package:myapp/widgets/lyrics_renderer.dart';
import 'package:myapp/key_relation.dart';

class SongDetailScreen extends StatefulWidget {
  final String songId;

  const SongDetailScreen({super.key, required this.songId});

  @override
  State<SongDetailScreen> createState() => _SongDetailScreenState();
}

class _SongDetailScreenState extends State<SongDetailScreen> {
  final SongService _songService = SongService();
  late Future<Song> _songFuture;
  int _transposeHalfSteps = 0;

  @override
  void initState() {
    super.initState();
    _songFuture = _songService.getSongById(widget.songId);
  }

  String _transposeLyrics(String lyrics, int semitones) {
    if (semitones == 0) {
      return lyrics;
    }
    final chordRegex = RegExp(r'\[([A-Ga-g][#b]?m?7?)\]');
    return lyrics.replaceAllMapped(chordRegex, (match) {
      final originalChord = match.group(1)!;
      final transposedChord = KeyRelation.transpose(originalChord, semitones);
      return '[$transposedChord]';
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Song>(
      future: _songFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Song not found.')),
          );
        }

        final song = snapshot.data!;
        final transposedKey = KeyRelation.transpose(song.key ?? '', _transposeHalfSteps);

        return Scaffold(
          appBar: AppBar(
            leading: BackButton(onPressed: () => GoRouter.of(context).go('/')),
            title: Text(song.title),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(song.title, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text('Artist: ${song.artist}', style: Theme.of(context).textTheme.titleMedium),
                if (song.composer != null && song.composer!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text('Composer: ${song.composer}', style: Theme.of(context).textTheme.titleSmall),
                  ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Key: ', style: TextStyle(fontSize: 16)),
                    Text(transposedKey, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    IconButton(icon: const Icon(Icons.remove), onPressed: () => setState(() => _transposeHalfSteps--)),
                    IconButton(icon: const Icon(Icons.add), onPressed: () => setState(() => _transposeHalfSteps++)),
                  ],
                ),
                const SizedBox(height: 16),
                LyricsRenderer(
                  content: _transposeLyrics(song.lyrics, _transposeHalfSteps),
                  lyricFontSize: 18,
                  chordFontSize: 16,
                  chordColor: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
