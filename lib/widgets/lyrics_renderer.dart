import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class LyricsRenderer extends StatelessWidget {
  final String content;
  final double lyricFontSize;
  final double chordFontSize;
  final Color textColor;
  final Color chordColor;

  const LyricsRenderer({
    super.key,
    required this.content,
    this.lyricFontSize = 16.0,
    this.chordFontSize = 14.0,
    this.textColor = Colors.black,
    this.chordColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    List<String> lines = content.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) => _buildLine(context, line)).toList(),
    );
  }

  Widget _buildLine(BuildContext context, String line) {
    final chordRegex = RegExp(r'\[([^\]]+)\]');
    String cleanLyrics = line.replaceAll(chordRegex, '');
    List<Widget> chords = [];
    
    int accumulatedLength = 0;
    for (var match in chordRegex.allMatches(line)) {
        final chordText = match.group(1)!;
        final textBeforeChord = line.substring(0, match.start - accumulatedLength);
        final offset = _getTextWidth(textBeforeChord, TextStyle(fontSize: lyricFontSize));
        
        chords.add(
            Positioned(
                left: offset,
                child: Text(
                    chordText,
                    style: TextStyle(
                        fontSize: chordFontSize,
                        fontWeight: FontWeight.bold,
                        color: chordColor,
                    ),
                ),
            ),
        );
        accumulatedLength += match.group(0)!.length;
    }


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            // Invisible row of chords to calculate height
            Row(children: [Text(" ", style: TextStyle(fontSize: chordFontSize, fontWeight: FontWeight.bold),)]), 
            ...chords
          ],
        ),
        Text(
          cleanLyrics,
          style: TextStyle(fontSize: lyricFontSize, color: textColor),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  double _getTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: ui.TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size.width;
  }
}
