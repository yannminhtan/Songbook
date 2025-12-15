import 'package:cloud_firestore/cloud_firestore.dart';

class Song {
  final String id;
  final String title;
  final String artist;
  final String? composer;
  final String lyrics;
  final String? key;
  final int? tempo;
  final String? uploaderId;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    this.composer,
    required this.lyrics,
    this.key,
    this.tempo,
    this.uploaderId,
  });

  // Convert a Song object into a map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'artist': artist,
      'composer': composer,
      'lyrics': lyrics,
      'key': key,
      'tempo': tempo,
      'uploaderId': uploaderId,
    };
  }

  // Create a Song object from a Firestore document
  factory Song.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Song(
      id: doc.id,
      title: data['title'] ?? '',
      artist: data['artist'] ?? '',
      composer: data['composer'] as String?,
      lyrics: data['lyrics'] ?? '',
      key: data['key'] as String?,
      tempo: data['tempo'] as int?,
      uploaderId: data['uploaderId'] as String?,
    );
  }

  // For updating, create a copy of the song with new values
  Song copyWith({
    String? id,
    String? title,
    String? artist,
    String? composer,
    String? lyrics,
    String? key,
    int? tempo,
    String? uploaderId,
  }) {
    return Song(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      composer: composer ?? this.composer,
      lyrics: lyrics ?? this.lyrics,
      key: key ?? this.key,
      tempo: tempo ?? this.tempo,
      uploaderId: uploaderId ?? this.uploaderId,
    );
  }
}
