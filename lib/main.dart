import 'package:drink_me/provider/data_provider.dart';
import 'package:drink_me/screens/intro_screen_controller.dart';
import 'package:drink_me/screens/root_screen.dart';
import 'package:drink_me/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'utils/colors.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider<DailyDatabase>(
        create: (context) => DailyDatabase(),
        child: DrinkMeApp(),
      ),
    ]),
  );
}

class DrinkMeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Drink Me',
      theme: ThemeData(
        fontFamily: 'Kollektif',
        primaryColor: kPrimaryColor,
        accentColor: kTertiaryColor,
        appBarTheme: AppBarTheme(elevation: 0),
      ),
      home: Splash(),
      routes: {
        AppRoutes.ROOT_SCREEN: (ctx) => RootScreen(),
      },
    );
  }
}
