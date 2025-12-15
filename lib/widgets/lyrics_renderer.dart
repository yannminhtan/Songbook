import 'package:flutter/material.dart';

class LyricsRenderer extends StatelessWidget {
  final String content;
  final double lyricFontSize;
  final double chordFontSize;
  final Color? textColor;
  final Color? chordColor;

  const LyricsRenderer({
    super.key,
    required this.content,
    this.lyricFontSize = 16.0,
    this.chordFontSize = 14.0,
    this.textColor,
    this.chordColor,
  });

  @override
  Widget build(BuildContext context) {
    final defaultTextColor = textColor ?? Theme.of(context).colorScheme.onSurface;
    final defaultChordColor = chordColor ?? Theme.of(context).colorScheme.primary;

    List<String> lines = content.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines
          .map((line) =>
              _buildLine(context, line, defaultTextColor, defaultChordColor))
          .toList(),
    );
  }

  Widget _buildLine(BuildContext context, String line, Color textColor, Color chordColor) {
    final segments = line.split(RegExp(r'(?=\[)')); // split before '['

    if (segments.isEmpty) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.end,
        alignment: WrapAlignment.start,
        spacing: 0, // Horizontal space between segments
        runSpacing: 4.0, // Vertical space between lines if wrapped
        children: segments.map((segment) {
          if (segment.isEmpty) return const SizedBox.shrink();

          final match = RegExp(r'\[([^\]]+)\](.*)', dotAll: true).firstMatch(segment);

          if (match != null) {
            final chord = match.group(1)!;
            final lyric = match.group(2)!;
            return _buildSegment(context, chord, lyric, textColor, chordColor);
          } else {
            return _buildSegment(context, null, segment, textColor, chordColor);
          }
        }).toList(),
      ),
    );
  }

  Widget _buildSegment(BuildContext context, String? chord, String lyric, Color textColor, Color chordColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          chord ?? '',
          style: TextStyle(
            fontSize: chordFontSize,
            fontWeight: FontWeight.bold,
            color: chordColor,
            height: 1,
          ),
        ),
        Text(
          lyric,
          style: TextStyle(
            fontSize: lyricFontSize,
            color: textColor,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
