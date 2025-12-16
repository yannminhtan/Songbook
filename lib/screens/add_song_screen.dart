import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/models/song_model.dart';
import 'package:myapp/services/song_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/key_relation.dart';

class AddSongScreen extends StatefulWidget {
  const AddSongScreen({super.key});

  @override
  State<AddSongScreen> createState() => _AddSongScreenState();
}

class _AddSongScreenState extends State<AddSongScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _artistController = TextEditingController();
  final _composerController = TextEditingController();
  final _lyricsController = TextEditingController();
  final _keyController = TextEditingController();
  final _tempoController = TextEditingController();

  final SongService _songService = SongService();
  final _auth = FirebaseAuth.instance;
  List<String> _suggestedChords = [];

  @override
  void initState() {
    super.initState();
    _keyController.addListener(_updateSuggestedChords);
  }

  @override
  void dispose() {
    _keyController.removeListener(_updateSuggestedChords);
    _titleController.dispose();
    _artistController.dispose();
    _composerController.dispose();
    _lyricsController.dispose();
    _keyController.dispose();
    _tempoController.dispose();
    super.dispose();
  }

  void _updateSuggestedChords() {
    setState(() {
      _suggestedChords = KeyRelation.getFamily(_keyController.text);
    });
  }

  void _insertChord(String chord) {
    final text = _lyricsController.text;
    final selection = _lyricsController.selection;
    final newText = text.replaceRange(selection.start, selection.end, '[$chord]');
    _lyricsController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: selection.start + chord.length + 2),
    );
  }

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
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(_artistController, 'Artist'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(_composerController, 'Composer', isRequired: false),
                  ),
                ],
              ),
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
              if (_suggestedChords.isNotEmpty)
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _suggestedChords.length,
                    itemBuilder: (context, index) {
                      final chord = _suggestedChords[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ElevatedButton(
                          onPressed: () => _insertChord(chord),
                          child: Text(chord),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),
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

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1, TextInputType? keyboardType, String? hint, bool isRequired = true}) {
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
      validator: (value) => isRequired && value!.isEmpty ? 'Please enter the $label' : null,
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
        composer: _composerController.text,
        lyrics: _lyricsController.text,
        key: _keyController.text,
        tempo: int.tryParse(_tempoController.text),
        uploaderId: user.uid,
      );

      final songId = await _songService.addSong(newSong);
      
      if (!mounted) return;
      GoRouter.of(context).push('/song/$songId');
    }
  }
}
