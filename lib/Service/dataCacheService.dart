import 'package:flutter/foundation.dart';
import 'package:quotes/model/quote.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quotes/model/quote.dart';

class DataCacheService {
  DataCacheService({@required this.sharedPreferences});
  final SharedPreferences sharedPreferences;

  List<Quote> getData() {
    List<Quote> values = [];
    print('count');
    final count = sharedPreferences.getInt('count');
    print(count);
    if (count != null) {
      for (var x = 0; x < count; x++) {
        final ID = sharedPreferences.getString("${x}/ID");
        final quote = sharedPreferences.getString('${x}/quote');
        final author = sharedPreferences.getString('${x}/author');

        values.add(
            Quote(id: int.parse(ID.toString()), quote: quote, author: author));
      }
    }

    return values;
  }

  // ignore: non_constant_identifier_names
  Future<void> setData(List<Quote> quoteList) async {
    int x = 0;
    for (var value in quoteList) {
      await sharedPreferences.setString(
          '${x.toString()}/ID', value.id.toString());
      await sharedPreferences.setString('${x.toString()}/quote', value.quote);
      await sharedPreferences.setString('${x.toString()}/author', value.author);
      x++;
    }
    await sharedPreferences.setInt('count', quoteList.length);
  }

  Future<Quote> getLastQuote() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastQuote = prefs.get("Quote");
      final lastQuoteAuthor = prefs.getString("Author");
      final lastQuoteId = prefs.getInt("Id");
      final isLiked = prefs.getBool("Liked");
      print(isLiked);
      return Quote(
          id: lastQuoteId,
          author: lastQuoteAuthor,
          quote: lastQuote,
          liked: isLiked);
    } catch (e) {
      print(e);
    }
  }

  setLastQuote(Quote quote) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("Quote", quote.quote);
    await prefs.setString("Author", quote.author);
    await prefs.setInt("Id", quote.id);
    await prefs.setBool("Liked", quote.liked);
  }

  setIsLiked(bool liked) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("Liked", liked);
  }
}
