class CitiesService {
  static final List<String> cities = [
    '1',
    '2',
    '3',
    '4',
    '5',
  ];

  static List<String> getSuggestions(String query) {
    List<String> matches = <String>[];
    matches.addAll(cities);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}