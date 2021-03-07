import 'package:flutter/material.dart';
import 'package:quotes/Screens/LikedQuoteScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/home.dart';
import 'Service/dataCacheService.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  final dataCache = DataCacheService(sharedPreferences: sharedPreferences);
  runApp(MyApp(dataCache: dataCache));
}

class MyApp extends StatelessWidget {
  final dataCache;
  MyApp({this.dataCache});

  // This widget is the root of your application.
  // ignore: empty_constructor_bodies
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        "/": (context) => Home(
              data: dataCache,
            ),
        Home.id: (context) => Home(),
        LikedQuotesScreen.id: (context) => LikedQuotesScreen(
              data: dataCache,
            ),
      },
    );
  }
}
