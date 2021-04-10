import 'package:drive_me/DataHandler/appData.dart';
import 'package:drive_me/Screens/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AppData(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Taxi App',
          initialRoute: MainScreen.idScreen,
          routes: {
            MainScreen.idScreen: (context) => MainScreen(),
          },
        ));
  }
}
