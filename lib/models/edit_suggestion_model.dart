import 'package:cloud_firestore/cloud_firestore.dart';

class EditSuggestion {
  final String id;
  final String songId;
  final String suggestedById;
  final String title;
  final String artist;
  final String lyrics;
  final String key;
  final int tempo;
  final DateTime createdAt;
  int upvotes;
  int downvotes;
  // 'pending', 'approved', 'rejected'
  String status;

  EditSuggestion({
    required this.id,
    required this.songId,
    required this.suggestedById,
    required this.title,
    required this.artist,
    required this.lyrics,
    required this.key,
    required this.tempo,
    required this.createdAt,
    this.upvotes = 0,
    this.downvotes = 0,
    this.status = 'pending',
  });

  factory EditSuggestion.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return EditSuggestion(
      id: doc.id,
      songId: data['songId'] ?? '',
      suggestedById: data['suggestedById'] ?? '',
      title: data['title'] ?? '',
      artist: data['artist'] ?? '',
      lyrics: data['lyrics'] ?? '',
      key: data['key'] ?? '',
      tempo: data['tempo'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      upvotes: data['upvotes'] ?? 0,
      downvotes: data['downvotes'] ?? 0,
      status: data['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'songId': songId,
      'suggestedById': suggestedById,
      'title': title,
      'artist': artist,
      'lyrics': lyrics,
      'key': key,
      'tempo': tempo,
      'createdAt': createdAt,
      'upvotes': upvotes,
      'downvotes': downvotes,
      'status': status,
    };
  }
}
