import 'quote.dart';

class LikedQuote {
  static List<Quote> likedQuote = [];

  static void addtoList(Quote quote) {
    likedQuote.add(quote);
    print(likedQuote.last.quote);
  }

  static void removeFromList(Quote quote) {
    likedQuote.remove(quote);
  }
}
