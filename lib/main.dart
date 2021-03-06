import 'package:flutter/material.dart';
import 'API/api.dart';
import 'package:quotes/model/quote.dart';
import 'package:quotes/API/api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Quote quote = Quote(id: 1, author: "yousef", quote: "test");
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
        title: Text(
          "Quotes",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.black,
              ),
              onPressed: () async {
                var data = await API.getQuote();
                setState(() {
                  quote = data;
                });
              }),
        ],
        elevation: 0,
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Card(
              child: Container(
                width: 250,
                height: 150,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        quote.quote,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Container(
                      width: 250,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "___" + quote.author,
                          style: TextStyle(fontSize: 8),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 0.5,
                    ),
                    Container(
                      height: 30,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.favorite_border_rounded,
                              ),
                              onPressed: () {
                                print("sfsdfsd");
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
