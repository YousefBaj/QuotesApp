import 'package:flutter/material.dart';
import 'package:quotes/Screens/LikedQuoteScreen.dart';

import 'Screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Home.id,
      routes: <String, WidgetBuilder>{
        "/": (context) => Home(),
        Home.id: (context) => Home(),
        LikedQuotesScreen.id: (context) => LikedQuotesScreen(),
      },
    );
  }
}
