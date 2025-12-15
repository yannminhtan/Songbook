class KeyRelation {
  static const List<String> _chromaticScale = [
    'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'
  ];

  static String transpose(String chord, int semitones) {
    final bool isMinor = chord.endsWith('m');
    final String root = chord.replaceAll('m', '');
    final int rootIndex = _chromaticScale.indexOf(root);
    if (rootIndex == -1) {
      return chord; 
    }
    final int transposedIndex = (rootIndex + semitones) % _chromaticScale.length;
    return _chromaticScale[transposedIndex] + (isMinor ? 'm' : '');
  }

  static List<String> getFamily(String key) {
    final bool isMinor = key.endsWith('m');
    final int rootIndex = _chromaticScale.indexOf(key.replaceAll('m', ''));
    if (rootIndex == -1) {
      return [];
    }

    if (isMinor) {
      return [
        _chromaticScale[rootIndex],
        _chromaticScale[(rootIndex + 3) % 12],
        _chromaticScale[(rootIndex + 5) % 12],
        _chromaticScale[(rootIndex + 7) % 12],
        _chromaticScale[(rootIndex + 8) % 12],
        _chromaticScale[(rootIndex + 10) % 12],
      ];
    } else {
      return [
        _chromaticScale[rootIndex],
        _chromaticScale[(rootIndex + 2) % 12] + 'm',
        _chromaticScale[(rootIndex + 4) % 12] + 'm',
        _chromaticScale[(rootIndex + 5) % 12],
        _chromaticScale[(rootIndex + 7) % 12],
        _chromaticScale[(rootIndex + 9) % 12] + 'm',
      ];
    }
  }
}
