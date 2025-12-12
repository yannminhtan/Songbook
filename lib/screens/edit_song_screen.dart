import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/models/song_model.dart';
import 'package:myapp/services/song_service.dart';

class EditSongScreen extends StatefulWidget {
  final String songId;

  const EditSongScreen({super.key, required this.songId});

  @override
  State<EditSongScreen> createState() => _EditSongScreenState();
}

class _EditSongScreenState extends State<EditSongScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _artistController = TextEditingController();
  final _lyricsController = TextEditingController();
  final _youtubeUrlController = TextEditingController();
  final SongService _songService = SongService();
  late Future<Song> _songFuture;

  @override
  void initState() {
    super.initState();
    _songFuture = _songService.getSongById(widget.songId);
    _songFuture.then((song) {
      _titleController.text = song.title;
      _artistController.text = song.artist;
      _lyricsController.text = song.lyrics;
      _youtubeUrlController.text = song.youtubeUrl ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Song'),
      ),
      body: FutureBuilder<Song>(
        future: _songFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a title' : null,
                  ),
                  TextFormField(
                    controller: _artistController,
                    decoration: const InputDecoration(labelText: 'Artist'),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter an artist' : null,
                  ),
                  TextFormField(
                    controller: _lyricsController,
                    decoration: const InputDecoration(labelText: 'Lyrics'),
                    maxLines: 10,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter lyrics' : null,
                  ),
                  TextFormField(
                    controller: _youtubeUrlController,
                    decoration: const InputDecoration(labelText: 'YouTube URL (Optional)'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final updatedSong = Song(
                          id: widget.songId,
                          title: _titleController.text,
                          artist: _artistController.text,
                          lyrics: _lyricsController.text,
                          youtubeUrl: _youtubeUrlController.text,
                        );
                        await _songService.updateSong(updatedSong);
                        if (!mounted) return;
                        context.pop();
                      }
                    },
                    child: const Text('Update Song'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
