extension ParseExtension on Map<String, dynamic> {
  String parseString(String index) {
    return tryParseString(index) ?? '';
  }

  String? tryParseString(String index) {
    final data = this[index];

    if (data == null) return data;

    try {
      return data.toString();
      // ignore: avoid_catches_without_on_clauses
    } catch (_) {
      return null;
    }
  }

  int parseInt(String index) {
    return tryParseInt(index) ?? 0;
  }

  int? tryParseInt(String index) {
    final data = this[index];

    if (data is double) {
      return data.toInt();
    }

    return int.tryParse(data.toString());
  }

  double parseDouble(String index) {
    return tryParseDouble(index) ?? 0;
  }

  double? tryParseDouble(String index) {
    return double.tryParse(this[index].toString());
  }

  bool parseBool(String index) {
    return tryParseBool(index) ?? false;
  }

  bool? tryParseBool(String index) {
    final data = this[index];

    if (data is bool) return data;

    return null;
  }
}
