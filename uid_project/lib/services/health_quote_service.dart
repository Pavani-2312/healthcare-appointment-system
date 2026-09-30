import 'dart:convert';
import 'package:http/http.dart' as http;

// REST API Service – fetches health quotes from a free public API
class HealthQuoteService {
  // Using quotable.io – free, no auth needed
  static const String _baseUrl =
      'https://api.quotable.io/quotes/random?tags=health,wisdom&limit=5';

  /// Fetches a list of health/wisdom quotes.
  /// Returns a list of [QuoteModel] on success, or throws on failure.
  static Future<List<QuoteModel>> fetchQuotes() async {
    final response = await http
        .get(Uri.parse(_baseUrl))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => QuoteModel.fromJson(json)).toList();
    } else {
      throw Exception(
        'Failed to load quotes. Status: ${response.statusCode}',
      );
    }
  }
}

/// Data class for a single quote from the API response
class QuoteModel {
  final String content;
  final String author;
  final List<String> tags;

  const QuoteModel({
    required this.content,
    required this.author,
    required this.tags,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      content: json['content'] as String? ?? '',
      author: json['author'] as String? ?? 'Unknown',
      tags: (json['tags'] as List<dynamic>?)
              ?.map((t) => t.toString())
              .toList() ??
          [],
    );
  }
}
