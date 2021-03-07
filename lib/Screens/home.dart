import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:quotes/API/api.dart';
import 'package:quotes/Screens/LikedQuoteScreen.dart';
import 'package:quotes/model/likedQuote.dart';
import 'package:quotes/model/quote.dart';

class Home extends StatefulWidget {
  static const String id = 'Home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Quote quote = Quote(id: 1, author: "yousef", quote: "test");
  bool liked = false;
  String _networkStatus = '';

  Connectivity connectivity = Connectivity();

  void checkConnectivity1() async {
    print('test');
    var connectivityResult = await connectivity.checkConnectivity();
    var conn = getConnectionValue(connectivityResult);
    setState(() {
      _networkStatus = 'Check Connection:: ' + conn;
    });
  }

  String getConnectionValue(var connectivityResult) {
    String status = '';
    switch (connectivityResult) {
      case ConnectivityResult.mobile:
        status = 'Mobile';
        break;
      case ConnectivityResult.wifi:
        status = 'Wi-Fi';
        break;
      case ConnectivityResult.none:
        _noInternet();
        status = 'None';
        break;
      default:
        status = 'None';
        break;
    }
    return status;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getQuote();
  }

  void getQuote() async {
    var data = await API.getQuote();
    setState(() {
      quote = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          FlatButton(
            onPressed: () => Navigator.pushNamed(context, LikedQuotesScreen.id),
            child: Text(
              'liked Quote',
              style: TextStyle(
                fontFamily: 'notoSans',
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      backgroundColor: Colors.teal,
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              bottom: 32,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Image.asset(
                    "assets/images/quote-left.png",
                    color: Colors.white.withOpacity(0.4),
                  ),
                  width: 100,
                  height: 100,
                ),
                SizedBox(
                  height: 50,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        quote.quote,
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: "notoSans",
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "___" + quote.author,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'notoSans',
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 80,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(
                        liked
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                      onPressed: () {
                        liked
                            ? LikedQuote.removeFromList(quote)
                            : LikedQuote.addtoList(quote);
                        setState(() {
                          liked = !liked;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: 32,
                      ),
                      onPressed: () async {
                        checkConnectivity1();
                        getQuote();
                        setState(() {
                          liked = false;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _noInternet() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(50),
              borderRadius: BorderRadius.circular(40),
            ),
            width: MediaQuery.of(context).size.width * 0.50,
            height: MediaQuery.of(context).size.height * 0.20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 100,
                  color: Color(0xffF74C5F),
                ),
                Text(
                  'No Internet connection',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
