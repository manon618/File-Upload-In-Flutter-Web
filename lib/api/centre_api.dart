import 'dart:convert';
import 'package:http/http.dart' as http;

class Centre {
  final String name, centreid;

  const Centre({
    required this.name,
    required this.centreid,
  });

  static Centre fromJson(Map<String, dynamic> json) => Centre(
        name: json['name'] + ' ' + json['code'].toString(),
        centreid: json['id'].toString(),
      );
}

class CentreApi {
  static Future<List<Centre>> getUserSuggestions(String query) async {
    const apiKey = 'infinite@2022';
    final url = Uri.parse('https://app.eimaths-th.com/api/searchdepartment');
    final response = await http.get(url, headers: {
      'X-Auth-Key': apiKey,
    });

    if (response.statusCode == 200) {
      final List centres = json.decode(response.body);

      return centres.map((json) => Centre.fromJson(json)).where((centres) {
        final nameLower = centres.name.toLowerCase();
        final queryLower = query.toLowerCase();

        return nameLower.contains(queryLower);
      }).toList();
    } else {
      throw Exception();
    }
  }
}
