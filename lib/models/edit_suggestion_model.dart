import 'package:cloud_firestore/cloud_firestore.dart';

class EditSuggestion {
  final String id;
  final String songId;
  final String suggestedById;
  final String title;
  final String artist;
  final String? composer;
  final String lyrics;
  final String? key;
  final int? tempo;
  final DateTime createdAt;
  final int upvotes;
  final int downvotes;

  EditSuggestion({
    required this.id,
    required this.songId,
    required this.suggestedById,
    required this.title,
    required this.artist,
    this.composer, // Made composer an optional named parameter
    required this.lyrics,
    this.key,
    this.tempo,
    required this.createdAt,
    this.upvotes = 0,
    this.downvotes = 0,
  });

  factory EditSuggestion.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return EditSuggestion(
      id: doc.id,
      songId: data['songId'] ?? '',
      suggestedById: data['suggestedById'] ?? '',
      title: data['title'] ?? '',
      artist: data['artist'] ?? '',
      composer: data['composer'],
      lyrics: data['lyrics'] ?? '',
      key: data['key'],
      tempo: data['tempo'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      upvotes: data['upvotes'] ?? 0,
      downvotes: data['downvotes'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'songId': songId,
      'suggestedById': suggestedById,
      'title': title,
      'artist': artist,
      'composer': composer,
      'lyrics': lyrics,
      'key': key,
      'tempo': tempo,
      'createdAt': Timestamp.fromDate(createdAt),
      'upvotes': upvotes,
      'downvotes': downvotes,
    };
  }
}
