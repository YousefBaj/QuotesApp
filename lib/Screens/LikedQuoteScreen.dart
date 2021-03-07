import 'package:flutter/material.dart';
import 'package:quotes/model/quote.dart';
import 'package:quotes/Service/dataCacheService.dart';
import '../model/likedQuote.dart';

class LikedQuotesScreen extends StatefulWidget {
  static const id = 'LikedQuoteScreen';
  DataCacheService data;
  LikedQuotesScreen({this.data});
  @override
  _LikedQuotesScreenState createState() => _LikedQuotesScreenState(data: data);
}

class _LikedQuotesScreenState extends State<LikedQuotesScreen> {
  var likedQuoteList = LikedQuote.likedQuote;

  final DataCacheService data;

  _LikedQuotesScreenState({this.data});
  final GlobalKey<AnimatedListState> key = GlobalKey();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllData();
  }

  void getAllData() async {
    var tempList = await data.getData();
    print(tempList);
    setState(() {
      likedQuoteList = tempList;
    });
  }

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
      body: likedQuoteList.length == 0 ? emptyList() : qutesList(),
    );
  }

  Widget emptyList() {
    return Center(
        child: Container(
      child: Text(
        'There Are Not Quotes In Liked List',
        style: TextStyle(
          color: Colors.black54,
          fontFamily: "notoSans",
        ),
      ),
    ));
  }

  Widget qutesList() {
    return AnimatedList(
      key: key,
      initialItemCount: likedQuoteList.length,
      itemBuilder: (BuildContext context, int index, animation) {
        return quoteCard(likedQuoteList[index], animation, index);
      },
    );
  }

  Widget quoteCard(Quote quote, Animation<double> animation, int index) {
    return SizeTransition(
      sizeFactor: animation,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.5,
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
                        fontSize: 18,
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
                        _removeLikedQout(quote, index);
                        data.setIsLiked(false);
                        data.setData(likedQuoteList);
                        LikedQuote.removeFromList(quote);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _removeLikedQout(Quote quote, int index) {
    Quote removedItem = likedQuoteList.removeAt(index);
    AnimatedListRemovedItemBuilder builder = (context, animation) {
      return quoteCard(removedItem, animation, index);
    };
    key.currentState.removeItem(index, builder);
  }
}
