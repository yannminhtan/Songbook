import 'package:cloud_firestore/cloud_firestore.dart';

class Song {
  final String id;
  final String title;
  final String artist;
  final String lyrics;
  final String? youtubeUrl;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.lyrics,
    this.youtubeUrl,
  });

  // Convert a Song object into a map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'artist': artist,
      'lyrics': lyrics,
      'youtubeUrl': youtubeUrl,
    };
  }

  // Create a Song object from a Firestore document
  factory Song.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Song(
      id: doc.id,
      title: data['title'] ?? '',
      artist: data['artist'] ?? '',
      lyrics: data['lyrics'] ?? '',
      youtubeUrl: data['youtubeUrl'] as String?,
    );
  }

  // For updating, create a copy of the song with new values
  Song copyWith({
    String? id,
    String? title,
    String? artist,
    String? lyrics,
    String? youtubeUrl,
  }) {
    return Song(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      lyrics: lyrics ?? this.lyrics,
      youtubeUrl: youtubeUrl ?? this.youtubeUrl,
    );
  }
}
