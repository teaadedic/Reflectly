// filepath: lib/services/quote_service.dart
import 'dart:convert';
import 'package:flutter/services.dart';

class QuoteService {
  static Future<List<String>> loadQuotes() async {
    final String response = await rootBundle.loadString('assets/quotes.json');
    final List<dynamic> data = json.decode(response);
    return data.cast<String>();
  }
}
