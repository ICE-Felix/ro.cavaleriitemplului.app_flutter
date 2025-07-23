class StringOperations {
  static String normalize(String input) {
    const diacriticMap = {
      'ă': 'a',
      'ǎ': 'a',
      'â': 'a',
      'á': 'a',
      'à': 'a',
      'ä': 'a',
      'ã': 'a',
      'å': 'a',
      'î': 'i',
      'ï': 'i',
      'í': 'i',
      'ì': 'i',
      'ș': 's',
      'ş': 's',
      'ț': 't',
      'ţ': 't',
      'é': 'e',
      'è': 'e',
      'ê': 'e',
      'ë': 'e',
      'ó': 'o',
      'ò': 'o',
      'ô': 'o',
      'ö': 'o',
      'õ': 'o',
      'ú': 'u',
      'ù': 'u',
      'û': 'u',
      'ü': 'u',
      'ç': 'c',
      'ñ': 'n',
    };

    return input
        .toLowerCase()
        .split('')
        .map((char) => diacriticMap[char] ?? char)
        .join();
  }
}
