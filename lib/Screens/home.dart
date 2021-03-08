import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:quotes/API/api.dart';
import 'package:quotes/Screens/LikedQuoteScreen.dart';
import 'package:quotes/Service/dataCacheService.dart';
import 'package:quotes/model/likedQuote.dart';
import 'package:quotes/model/quote.dart';

class Home extends StatefulWidget {
  static const String id = 'Home';
  DataCacheService data;
  Home({this.data});
  @override
  _HomeState createState() => _HomeState(data: data);
}

class _HomeState extends State<Home> {
  Quote quote = Quote(id: 1, author: "", quote: "", liked: false);
  bool showSpinner = false;
  final DataCacheService data;

  _HomeState({this.data});
  bool liked = false;

  Connectivity connectivity = Connectivity();

  Future<String> checkConnectivity1() async {
    var connectivityResult = await connectivity.checkConnectivity();

    return getConnectionValue(connectivityResult);
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
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    getLastQuote();
  }

  void getLastQuote() async {
    var lastQuote = await data.getLastQuote() as Quote;
    print('test');
    if (lastQuote.quote != null) {
      setState(() {
        quote = lastQuote;
        liked = quote.liked;
      });
    } else {
      getQuote();
    }
  }

  void getQuote() async {
    String status = await checkConnectivity1();

    if (status != 'None') {
      setState(() {
        showSpinner = true;
        liked = false;
      });
      var newQuote = await API.getQuote();
      data.setLastQuote(newQuote);
      setState(() {
        showSpinner = false;
        quote = newQuote;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
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
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(
          backgroundColor: Colors.transparent,
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
          strokeWidth: 5,
        ),
        child: Center(
          child: Container(
            height: height,
            width: width,
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
                    width: width * 0.25,
                    height: width * 0.25,
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          quote.quote,
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: "notoSans",
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "- " + quote.author,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'notoSans',
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.05,
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
                            data.setData(LikedQuote.likedQuote);
                            liked = !liked;
                            data.setIsLiked(liked);
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
                          getQuote();
                        },
                      ),
                    ],
                  ),
                ],
              ),
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
              color: Colors.white.withAlpha(100),
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
