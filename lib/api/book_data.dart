import 'dart:convert';
import 'package:http/http.dart' as http;

class Book {
  final String name, bookid;

  const Book({
    required this.name,
    required this.bookid,
  });

  static Book fromJson(Map<String, dynamic> json) => Book(
        name: json['name'].toString(),
        bookid: json['id'].toString(),
      );
}

class BookApi {
  static Future<List<Book>> getBookSuggestions(
      String query, String level, String term) async {
    const apiKey = 'infinite@2022';
    final url = Uri.parse(
        'https://app.eimaths-th.com/api/searchbook?level=$level&term=$term');
    final response = await http.get(url, headers: {
      'X-Auth-Key': apiKey,
    });

    print('selectedCentreth: $url');

    if (response.statusCode == 200) {
      final List book = json.decode(response.body);

      return book.map((json) => Book.fromJson(json)).where((book) {
        final nameLower = book.name.toLowerCase();
        final queryLower = query.toLowerCase();

        return nameLower.contains(queryLower);
      }).toList();
    } else {
      throw Exception();
    }
  }
}
