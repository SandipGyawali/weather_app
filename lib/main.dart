import 'package:flutter/material.dart';
import 'package:weather_app/pages/weather_screen.dart';
import "package:flutter_dotenv/flutter_dotenv.dart";

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(useMaterial3: true),
      home: const WeatherScreen(),
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
    );
  }
}
