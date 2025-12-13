import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/models/song_model.dart';

class SongPostCard extends StatelessWidget {
  final Song song;

  const SongPostCard({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: () => context.go('/song/${song.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(song.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 4.0),
              Text(song.artist, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16.0),
              // A simple preview of the lyrics
              Text(
                song.lyrics,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
              ),
              const Divider(height: 32.0),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionButton(context, icon: Icons.thumb_up_alt_outlined, label: 'Like', onPressed: () {}),
        _buildActionButton(context, icon: Icons.comment_outlined, label: 'Comment', onPressed: () {}),
        _buildActionButton(context, icon: Icons.share_outlined, label: 'Share', onPressed: () {}),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, {required IconData icon, required String label, required VoidCallback onPressed}) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20.0),
      label: Text(label),
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
