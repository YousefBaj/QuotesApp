import 'package:flutter/material.dart';
import 'package:quotes/model/quote.dart';

import '../model/likedQuote.dart';

class LikedQuotesScreen extends StatefulWidget {
  static const id = 'LikedQuoteScreen';
  @override
  _LikedQuotesScreenState createState() => _LikedQuotesScreenState();
}

class _LikedQuotesScreenState extends State<LikedQuotesScreen> {
  final likedQuoteList = LikedQuote.likedQuote;
final key = GlobalKey<AnimatedListState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Liked Quotes',
          style: TextStyle(fontFamily: 'notoSans', color: Colors.teal),
        ),
        iconTheme: IconThemeData(
          color: Colors.teal, //change your color here
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: AnimatedList(
        key: key,
        initialItemCount: likedQuoteList.length,
        itemBuilder: (BuildContext context, int index,animation) {
          return quoteCard(likedQuoteList[index],animation);
        },
      ),
    );
  }

  Widget quoteCard(Quote quote, Animation<double> animation) {
    scale: animation,
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
      child: Container(
        height: 500,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            topLeft: Radius.circular(5),
            bottomRight: Radius.circular(5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.teal.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
          color: Colors.teal,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quote.quote,
                  style: TextStyle(
                      fontFamily: 'notoSans',
                      fontSize: 22,
                      color: Colors.white),
                ),
                Text(
                  "- " + quote.author,
                  style: TextStyle(
                    fontFamily: 'notoSans',
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                IconButton(
                  icon: Icon(
                    Icons.favorite_rounded,
                    color: Colors.white,
                    size: 35,
                  ),
                  onPressed: () {
                    setState(() {
                      likedQuoteList.remove(quote);
                      LikedQuote.removeFromList(quote);
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
