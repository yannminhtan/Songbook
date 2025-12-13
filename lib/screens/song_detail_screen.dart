import 'package:flutter/material.dart';
import 'package:myapp/models/song_model.dart';
import 'package:myapp/widgets/lyrics_renderer.dart';

class SongDetailScreen extends StatelessWidget {
  final String songId;

  const SongDetailScreen({super.key, required this.songId});

  @override
  Widget build(BuildContext context) {
    // Sample song data
    const String sampleLyrics = '''
မင်း[G]မချစ်တဲ့ လော[C]ကမှာကိုယ့်ဘဝ
အဓိပ္ပါယ်မဲ့[D] ဥပေက္ခာတွေသိပ်များ[G]
တစ်[C]ယောက်တည်းပဲ လျှောက်[G]လှမ်းနေရလည်း
မင်း[D]ရှိတဲ့အရပ်ကိုပဲ သစ္စာ[G]ပြုထား
''';

    final song = Song(
      id: songId,
      title: 'Sample Song',
      artist: 'Sample Artist',
      lyrics: sampleLyrics,
      key: 'G',
      tempo: 120,
      uploaderId: 'sample-uploader',
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(song.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              song.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              song.artist,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            LyricsRenderer(
              content: song.lyrics,
              lyricFontSize: 18,
              chordFontSize: 16,
              chordColor: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
