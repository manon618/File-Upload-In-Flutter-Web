import 'dart:convert';
import 'package:http/http.dart' as http;

class Subject {
  final String name, subid;

  const Subject({
    required this.name,
    required this.subid,
  });

  static Subject fromJson(Map<String, dynamic> json) => Subject(
        name: json['name'].toString(),
        subid: json['id'].toString(),
      );
}

class SubjectApi {
  static Future<List<Subject>> getSubjectSuggestions(
      String query, String std) async {
    const apiKey = 'infinite@2022';
    final url =
        Uri.parse('https://app.eimaths-th.com/api/searchsubject?std=$std');
    final response = await http.get(url, headers: {
      'X-Auth-Key': apiKey,
    });

    if (response.statusCode == 200) {
      final List subject = json.decode(response.body);

      return subject.map((json) => Subject.fromJson(json)).where((subject) {
        final nameLower = subject.name.toLowerCase();
        final queryLower = query.toLowerCase();

        return nameLower.contains(queryLower);
      }).toList();
    } else {
      throw Exception();
    }
  }
}
