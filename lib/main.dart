import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'Screens/Home_Screen.dart';


final Color greencolor = Colors.deepPurple;
double custFontSize = 20;
final String APPNAME = "English to Lao";


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  // MobileAds.instance.initialize();

  runApp(MaterialApp(
    builder: _builder,
    home: Home_Screen(),
    debugShowCheckedModeBanner: false,
    title: "$APPNAME",
    theme: ThemeData(primarySwatch: Colors.teal),
  ));
}


Widget _builder(BuildContext context, Widget? child) {
  return SafeArea(
    top: false,
    child: child!,
  );
}