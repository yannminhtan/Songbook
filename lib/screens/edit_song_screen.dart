import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/models/song_model.dart';
import 'package:myapp/models/edit_suggestion_model.dart';
import 'package:myapp/services/song_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final _keyController = TextEditingController();
  final _tempoController = TextEditingController();

  final SongService _songService = SongService();
  final _auth = FirebaseAuth.instance;
  late Future<Song> _songFuture;

  @override
  void initState() {
    super.initState();
    _songFuture = _songService.getSongById(widget.songId);
    _songFuture.then((song) {
      _titleController.text = song.title;
      _artistController.text = song.artist;
      _lyricsController.text = song.lyrics;
      _keyController.text = song.key ?? '';
      _tempoController.text = song.tempo?.toString() ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suggest an Edit'),
      ),
      body: FutureBuilder<Song>(
        future: _songFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildTextField(_titleController, 'Title'),
                  const SizedBox(height: 16),
                  _buildTextField(_artistController, 'Artist'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(_keyController, 'Key (e.g., G, Am)'),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          _tempoController,
                          'Tempo (BPM)',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(_lyricsController, 'Lyrics with Chords', maxLines: 15),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _submitSuggestion,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text('Submit Suggestion'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1, TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (value) => value!.isEmpty ? 'Please enter the $label' : null,
    );
  }

  void _submitSuggestion() async {
    if (_formKey.currentState!.validate()) {
      final user = _auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must be logged in to suggest an edit.')),
        );
        return;
      }

      final suggestion = EditSuggestion(
        id: '',
        songId: widget.songId,
        suggestedById: user.uid,
        title: _titleController.text,
        artist: _artistController.text,
        lyrics: _lyricsController.text,
        key: _keyController.text,
        tempo: int.tryParse(_tempoController.text) ?? 0,
        createdAt: DateTime.now(),
      );

      await _songService.submitEditSuggestion(suggestion);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thank you! Your suggestion has been submitted.')),
      );
      context.pop();
    }
  }
}
