import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/models/song_model.dart';
import 'package:myapp/services/song_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final _keyController = TextEditingController();
  final _tempoController = TextEditingController();

  final SongService _songService = SongService();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a New Song'),
      ),
      body: Form(
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
              _buildTextField(
                _lyricsController,
                'Lyrics with Chords',
                maxLines: 15,
                hint: 'Use [C]Am to specify chords. e.g., မင်း[G]မချစ်တဲ့ လော[C]ကမှာကိုယ့်ဘဝ'
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _addSong,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Submit Song'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1, TextInputType? keyboardType, String? hint}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (value) => value!.isEmpty ? 'Please enter the $label' : null,
    );
  }

  void _addSong() async {
    if (_formKey.currentState!.validate()) {
      final user = _auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must be logged in to add a song.')),
        );
        return;
      }

      final newSong = Song(
        id: '', 
        title: _titleController.text,
        artist: _artistController.text,
        lyrics: _lyricsController.text,
        key: _keyController.text,
        tempo: int.tryParse(_tempoController.text),
        uploaderId: user.uid,
      );

      await _songService.addSong(newSong);
      
      if (!mounted) return;
      context.pop();
    }
  }
}
