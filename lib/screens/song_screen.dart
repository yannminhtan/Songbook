import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/models/song_model.dart';
import 'package:myapp/models/edit_suggestion_model.dart';
import 'package:myapp/services/song_service.dart';
import 'package:myapp/widgets/lyrics_renderer.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SongScreen extends StatefulWidget {
  final String songId;

  const SongScreen({super.key, required this.songId});

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  final SongService _songService = SongService();
  final _auth = FirebaseAuth.instance;
  late Future<Song> _songFuture;
  late Stream<List<EditSuggestion>> _suggestionsStream;

  @override
  void initState() {
    super.initState();
    _songFuture = _songService.getSongById(widget.songId);
    _suggestionsStream = _songService.getSuggestionsForSong(widget.songId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Song>(
      future: _songFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        }

        final song = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: Text(song.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_note),
                onPressed: () => context.go('/edit-song/${song.id}'),
                tooltip: 'Suggest an Edit',
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(song.artist, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 16),
                LyricsRenderer(content: song.lyrics),
                const Divider(height: 40, thickness: 2),
                _buildSuggestionsSection(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSuggestionsSection() {
    return StreamBuilder<List<EditSuggestion>>(
      stream: _suggestionsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No edit suggestions yet.'));
        }

        final suggestions = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Edit Suggestions', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                return _buildSuggestionCard(suggestions[index]);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSuggestionCard(EditSuggestion suggestion) {
    final canApprove = _auth.currentUser?.uid == suggestion.suggestedById; // Simplified approval logic

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Suggested changes:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            // Display a diff of the changes (simplified for now)
            Text('Title: ${suggestion.title}'),
            Text('Artist: ${suggestion.artist}'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.thumb_up_outlined), 
                  onPressed: () => _songService.voteOnSuggestion(suggestion.id, true),
                ),
                Text('${suggestion.upvotes}'),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.thumb_down_outlined), 
                  onPressed: () => _songService.voteOnSuggestion(suggestion.id, false),
                ),
                Text('${suggestion.downvotes}'),
                const Spacer(),
                if (canApprove)
                  ElevatedButton(
                    onPressed: () => _songService.approveSuggestion(suggestion),
                    child: const Text('Approve'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
