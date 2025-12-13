import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/song_model.dart';
import 'package:myapp/models/edit_suggestion_model.dart'; // Import the new model

class SongService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _songsCollection;
  late final CollectionReference _suggestionsCollection;

  SongService() {
    _songsCollection = _firestore.collection('songs');
    _suggestionsCollection = _firestore.collection('editSuggestions');
  }

  // Add a new song
  Future<void> addSong(Song song) {
    return _songsCollection.add(song.toMap());
  }

  // Get a stream of songs
  Stream<List<Song>> getSongs() {
    return _songsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Song.fromFirestore(doc)).toList();
    });
  }

  // Update an existing song
  Future<void> updateSong(Song song) {
    return _songsCollection.doc(song.id).update(song.toMap());
  }

  // Delete a song
  Future<void> deleteSong(String songId) {
    return _songsCollection.doc(songId).delete();
  }

  // Get a single song by ID
  Future<Song> getSongById(String songId) async {
    DocumentSnapshot doc = await _songsCollection.doc(songId).get();
    return Song.fromFirestore(doc);
  }

  // Submit an edit suggestion
  Future<void> submitEditSuggestion(EditSuggestion suggestion) {
    return _suggestionsCollection.add(suggestion.toFirestore());
  }

  // Get suggestions for a song
  Stream<List<EditSuggestion>> getSuggestionsForSong(String songId) {
    return _suggestionsCollection
        .where('songId', isEqualTo: songId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => EditSuggestion.fromFirestore(doc)).toList());
  }

  // Vote on a suggestion
  Future<void> voteOnSuggestion(String suggestionId, bool isUpvote) async {
    final suggestionRef = _suggestionsCollection.doc(suggestionId);
    return _firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(suggestionRef);
      if (!snapshot.exists) {
        throw Exception("Suggestion does not exist!");
      }
      int newUpvotes = snapshot.get('upvotes') + (isUpvote ? 1 : 0);
      int newDownvotes = snapshot.get('downvotes') + (isUpvote ? 0 : 1);
      transaction.update(suggestionRef, {'upvotes': newUpvotes, 'downvotes': newDownvotes});
    });
  }

  // Approve a suggestion
  Future<void> approveSuggestion(EditSuggestion suggestion) async {
    final songRef = _songsCollection.doc(suggestion.songId);
    final suggestionRef = _suggestionsCollection.doc(suggestion.id);

    final updatedSong = Song(
        id: suggestion.songId,
        title: suggestion.title,
        artist: suggestion.artist,
        lyrics: suggestion.lyrics,
    );

    await _firestore.runTransaction((transaction) async {
      transaction.update(songRef, updatedSong.toMap());
      transaction.update(suggestionRef, {'status': 'approved'});
    });
  }
}
