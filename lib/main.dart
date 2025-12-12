import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- ၁။ Entry Point (အက်ပ် စတင်ရာ) ---
void main() {
  runApp(const KaeKaeSongbookApp());
}

class KaeKaeSongbookApp extends StatelessWidget {
  const KaeKaeSongbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KaeKae Songbook',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // အရောင် Theme (Dark Guitar Vibe)
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.dark,
        ),
        // မြန်မာစာ ဖောင့်အလှ
        textTheme: GoogleFonts.notoSansMyanmarTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

// --- ၂။ OOP Models (Data ပုံစံခွက်) ---
class Song {
  String id;
  String title;
  String artist;
  String content;
  bool isFavorite;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.content,
    this.isFavorite = false,
  });
}

// --- ၃။ Screen Views (မျက်နှာပြင်များ) ---

// (က) ပင်မ စာမျက်နှာ (သီချင်းစာရင်း)
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Song> _songs = [
    Song(
      id: '1',
      title: 'အချစ်သီချင်း',
      artist: 'Example Artist',
      content:
          "[C]မင်းနဲ့တွေ့မှ [Am]ချစ်တတ်လာပြီ...\n[F]ကမ္ဘာကြီးက [G]သာယာသွား...",
      isFavorite: true,
    ),
    Song(
      id: '2',
      title: 'လမ်းခွဲ',
      artist: 'Rock Star',
      content:
          "[Em]ဝေးသွားလည်း [D]မေ့မရပါ...\n[C]ပြန်လာခဲ့ပါ [G]ချစ်သူ...",
    ),
  ];

  void _addNewSong(Song newSong) {
    setState(() {
      _songs.add(newSong);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KaeKae Songbook 🎸'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.person)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddSongScreen(onSave: _addNewSong),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('သီချင်းသစ်'),
      ),
      body: ListView.builder(
        itemCount: _songs.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final song = _songs[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 4,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.deepOrange.shade800,
                child: const Icon(Icons.music_note, color: Colors.white),
              ),
              title: Text(
                song.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(song.artist),
              trailing: IconButton(
                icon: Icon(
                  song.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: song.isFavorite ? Colors.red : null,
                ),
                onPressed: () {
                  setState(() {
                    song.isFavorite = !song.isFavorite;
                  });
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SongDetailScreen(song: song),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// (ခ) သီချင်း အသေးစိတ်ကြည့်သည့် စာမျက်နှာ (Detail View)
class SongDetailScreen extends StatelessWidget {
  final Song song;
  const SongDetailScreen({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(song.title),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.share))],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.album, size: 40, color: Colors.grey),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      song.artist,
                      style: const TextStyle(color: Colors.deepOrangeAccent),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 30),
            LyricsRenderer(text: song.content),
          ],
        ),
      ),
    );
  }
}

// (ဂ) သီချင်းအသစ် ထည့်သည့် စာမျက်နှာ (Form View)
class AddSongScreen extends StatefulWidget {
  final Function(Song) onSave;
  const AddSongScreen({super.key, required this.onSave});

  @override
  State<AddSongScreen> createState() => _AddSongScreenState();
}

class _AddSongScreenState extends State<AddSongScreen> {
  final _titleController = TextEditingController();
  final _artistController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('သီချင်းအသစ် ထည့်မည်')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'သီချင်းခေါင်းစဉ်',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _artistController,
              decoration: const InputDecoration(
                labelText: 'အဆိုတော် အမည်',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _contentController,
              maxLines: 15,
              decoration: const InputDecoration(
                labelText: 'သီချင်းစာသားနှင့် Chords',
                hintText: '[C]မင်းနဲ့တွေ့မှ [Am]ချစ်တတ်လာပြီ...\n(Chord များကို ကွင်းစကွင်းပိတ်ဖြင့် ရေးပါ)',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              style: GoogleFonts.robotoMono(),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  final newSong = Song(
                    id: DateTime.now().toString(),
                    title: _titleController.text,
                    artist: _artistController.text,
                    content: _contentController.text,
                  );
                  widget.onSave(newSong);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.save),
                label: const Text('သိမ်းဆည်းမည်'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- ၄။ Custom Widgets (UPDATED) ---

class LyricsRenderer extends StatelessWidget {
  final String text;
  final TextStyle? chordStyle;
  final TextStyle? lyricStyle;

  const LyricsRenderer({
    super.key,
    required this.text,
    this.lyricStyle,
    this.chordStyle,
  });

  @override
  Widget build(BuildContext context) {
    final defaultChordStyle = GoogleFonts.robotoMono(
      color: Colors.deepOrangeAccent,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );
    final defaultLyricStyle = GoogleFonts.robotoMono(
      color: Colors.white,
      fontSize: 16,
      height: 2.5,
    );

    final finalChordStyle = chordStyle ?? defaultChordStyle;
    final finalListStyle = lyricStyle ?? defaultLyricStyle;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: text.split('\n').map((line) {
        return RichText(
          text: _parseLine(line, finalChordStyle, finalListStyle),
        );
      }).toList(),
    );
  }

  InlineSpan _parseLine(String line, TextStyle chordStyle, TextStyle lyricStyle) {
    final regex = RegExp(r'(\[[^\]]+\])');
    final spans = <InlineSpan>[];
    int currentPosition = 0;

    for (final match in regex.allMatches(line)) {
      // Add the lyric text before the chord
      if (match.start > currentPosition) {
        spans.add(TextSpan(
          text: line.substring(currentPosition, match.start),
          style: lyricStyle,
        ));
      }

      // Add the chord itself as a WidgetSpan
      final chordText = match.group(0)!.replaceAll(RegExp(r'[\[\]]'), '');
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.bottom,
          child: Transform.translate(
            offset: const Offset(0, -14.0), // Raise the chord
            child: Text(chordText, style: chordStyle),
          ),
        ),
      );
      
      // Add a non-breaking space to maintain position for the lyric that was under the chord
      spans.add(TextSpan(text: ' ', style: lyricStyle));

      // Update the current position to be after the chord
      currentPosition = match.end;
    }

    // Add any remaining lyric text after the last chord
    if (currentPosition < line.length) {
      spans.add(TextSpan(
        text: line.substring(currentPosition),
        style: lyricStyle,
      ));
    }

    // If there were no chords in the line, just display the line
    if (spans.isEmpty) {
      return TextSpan(text: line, style: lyricStyle);
    }

    return TextSpan(children: spans);
  }
}
