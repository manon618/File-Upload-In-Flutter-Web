import 'dart:convert';
import 'package:http/http.dart' as http;

class Term {
  final String name, termid;

  const Term({
    required this.name,
    required this.termid,
  });

  static Term fromJson(Map<String, dynamic> json) => Term(
        name: json['name'].toString(),
        termid: json['name'].toString(),
      );
}

class TermApi {
  static Future<List<Term>> getTermSuggestions(
      String query, String level) async {
    const apiKey = 'infinite@2022';
    final url =
        Uri.parse('https://app.eimaths-th.com/api/searchterm?level=$level');
    final response = await http.get(url, headers: {
      'X-Auth-Key': apiKey,
    });

    if (response.statusCode == 200) {
      final List term = json.decode(response.body);

      return term.map((json) => Term.fromJson(json)).where((term) {
        final nameLower = term.name.toLowerCase();
        final queryLower = query.toLowerCase();

        return nameLower.contains(queryLower);
      }).toList();
    } else {
      throw Exception();
    }
  }
}
