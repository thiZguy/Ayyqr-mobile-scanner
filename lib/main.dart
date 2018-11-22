import 'package:flutter/material.dart';
import 'package:qrtest/screens/splash_screen.dart';
import './screens/landing_screen.dart';
void main(){
  runApp(new MaterialApp(
    theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blueGrey,
        accentColor: Colors.teal,
    ),
    home: new SplashScreen(),
    routes: <String, WidgetBuilder>{
      '/LandingScreen': (BuildContext context) => new LandingScreen(),
    },
  ));
}