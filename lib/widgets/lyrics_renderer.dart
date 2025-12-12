import 'package:flutter/material.dart';

class LyricsRenderer extends StatelessWidget {
  final String content;

  const LyricsRenderer({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    List<TextSpan> spans = [];
    List<String> lines = content.split('\n');

    for (String line in lines) {
      List<String> parts = line.split(RegExp(r'(\[.*?\])'));
      for (String part in parts) {
        if (part.startsWith('[') && part.endsWith(']')) {
          spans.add(TextSpan(
            text: part.substring(1, part.length - 1),
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
          ));
        } else {
          spans.add(TextSpan(text: part));
        }
      }
      spans.add(const TextSpan(text: '\n'));
    }

    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: spans,
      ),
    );
  }
}
