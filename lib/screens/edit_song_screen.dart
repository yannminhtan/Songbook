import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/models/song_model.dart';
import 'package:myapp/models/edit_suggestion_model.dart';
import 'package:myapp/services/song_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/key_relation.dart';

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
  final _composerController = TextEditingController();
  final _lyricsController = TextEditingController();
  final _keyController = TextEditingController();
  final _tempoController = TextEditingController();

  final SongService _songService = SongService();
  final _auth = FirebaseAuth.instance;
  late Future<Song> _songFuture;
  List<String> _suggestedChords = [];
  bool _isContentChanged = false;

  @override
  void initState() {
    super.initState();
    _songFuture = _songService.getSongById(widget.songId);
    _songFuture.then((song) {
      _titleController.text = song.title;
      _artistController.text = song.artist;
      _composerController.text = song.composer ?? '';
      _lyricsController.text = song.lyrics;
      _keyController.text = song.key ?? '';
      _tempoController.text = song.tempo?.toString() ?? '';
      _updateSuggestedChords();
    });
    _keyController.addListener(_updateSuggestedChords);
    _titleController.addListener(_setContentChanged);
    _artistController.addListener(_setContentChanged);
    _composerController.addListener(_setContentChanged);
    _lyricsController.addListener(_setContentChanged);
    _keyController.addListener(_setContentChanged);
    _tempoController.addListener(_setContentChanged);
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

  void _setContentChanged() {
    if (!_isContentChanged) {
      setState(() {
        _isContentChanged = true;
      });
    }
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

  Future<bool> _onWillPop() async {
    if (!_isContentChanged) {
      return true;
    }

    final shouldPop = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save changes?'),
        content: const Text('Do you want to save the changes you made?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Don\'t Save'),
          ),
          TextButton(
            onPressed: () {
              _submitSuggestion();
              Navigator.of(context).pop(true);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    return shouldPop ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isContentChanged,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop) {
          if(mounted) Navigator.pop(context);
        }
      },
      child: Scaffold(
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
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(_artistController, 'Artist'),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(_composerController, 'Composer'),
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
                      hintText: 'Use [C]Am to specify chords. e.g., မင်း[G]မချစ်တဲ့ လော[C]ကမှာကိုယ့်ဘဝ'
                    ),
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
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1, TextInputType? keyboardType, String? hintText}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: const OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (value) => value!.isEmpty && label != 'Composer' ? 'Please enter the $label' : null, 
    );
  }

  void _submitSuggestion() async {
    if (_formKey.currentState!.validate()) {
      final user = _auth.currentUser;
      final router = GoRouter.of(context);
      final messenger = ScaffoldMessenger.of(context);

      if (user == null) {
        messenger.showSnackBar(
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
        composer: _composerController.text, 
        lyrics: _lyricsController.text,
        key: _keyController.text,
        tempo: int.tryParse(_tempoController.text) ?? 0,
        createdAt: DateTime.now(),
      );

      await _songService.submitEditSuggestion(suggestion);

      messenger.showSnackBar(
        const SnackBar(content: Text('Thank you! Your suggestion has been submitted.')),
      );
      router.pop();
    }
  }
}
