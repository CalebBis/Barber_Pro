String toTitleCase(String text) {
  if (text.trim().isEmpty) return text;
  return text.trim().split(' ').map((word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');
}

String toSentenceCase(String text) {
  if (text.trim().isEmpty) return text;
  final trimmed = text.trim();
  return trimmed[0].toUpperCase() + trimmed.substring(1).toLowerCase();
}
