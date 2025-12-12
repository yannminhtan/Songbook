import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/models/song_model.dart';
import 'package:myapp/services/song_service.dart';

class AddSongScreen extends StatefulWidget {
  const AddSongScreen({super.key});

  @override
  State<AddSongScreen> createState() => _AddSongScreenState();
}

class _AddSongScreenState extends State<AddSongScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _artistController = TextEditingController();
  final _lyricsController = TextEditingController();
  final _youtubeUrlController = TextEditingController();
  final SongService _songService = SongService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a New Song'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
              ),
              TextFormField(
                controller: _artistController,
                decoration: const InputDecoration(labelText: 'Artist'),
                validator: (value) => value!.isEmpty ? 'Please enter an artist' : null,
              ),
              TextFormField(
                controller: _lyricsController,
                decoration: const InputDecoration(labelText: 'Lyrics'),
                maxLines: 10,
                validator: (value) => value!.isEmpty ? 'Please enter lyrics' : null,
              ),
              TextFormField(
                controller: _youtubeUrlController,
                decoration: const InputDecoration(labelText: 'YouTube URL (Optional)'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final newSong = Song(
                      id: '', // Firestore will generate the ID
                      title: _titleController.text,
                      artist: _artistController.text,
                      lyrics: _lyricsController.text,
                      youtubeUrl: _youtubeUrlController.text,
                    );
                    await _songService.addSong(newSong);
                    if (!mounted) return;
                    context.pop();
                  }
                },
                child: const Text('Add Song'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
