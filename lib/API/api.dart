import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quotes/model/quote.dart';

class API {
  static final String baseUrl =
      "http://quotes.stormconsultancy.co.uk/random.json";

  static Future<Quote> getQuote() async {
    http.Response response = await http.get(
      Uri.parse(baseUrl),
    );

    var data = json.decode(response.body);
    return Quote(id: data['id'], author: data['author'], quote: data['quote']);
  }
}
