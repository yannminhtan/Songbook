import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/song_model.dart';

class SongService {
  final CollectionReference _songsCollection = FirebaseFirestore.instance.collection('songs');

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
}
