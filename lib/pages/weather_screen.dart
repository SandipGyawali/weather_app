import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weather_app/components/add_forecast.dart';
import 'package:weather_app/components/forecast_box.dart';
import "package:http/http.dart" as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreen();
}

class _WeatherScreen extends State<WeatherScreen> {
  var coord;
  var weatherMain;
  var currentSky;
  var wind;
  var foreCastList;

  final cityName = "London";
  bool isLoading = true; // Add a loading state

  @override
  void initState() {
    super.initState();
    getCurrentWeatherData(); // Fetch weather data when the widget is initialized
  }

  Future<void> getCurrentWeatherData() async {
    try {
      final apiKey = dotenv.env["WEATHER_API_KEY"];
      final response = await http.get(
        Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?q=$cityName,uk&APPID=$apiKey",
        ),
      );

      final responseList = await http.get(
        Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$cityName,uk&appid=$apiKey",
        ),
      );
      var _weatherList = jsonDecode(responseList.body);

      var _weather = jsonDecode(response.body);

      if (_weather != null) {
        print(_weather);
        setState(() {
          foreCastList = _weatherList["list"];
          coord = _weather["coord"];
          weatherMain = _weather["main"];
          currentSky = _weather["weather"][0];
          wind = _weather["wind"];

          isLoading = false; // Data fetched successfully, stop loading
        });
      }
    } catch (err, s) {
      print(s);
      print(err);
      setState(() {
        isLoading = false; // Stop loading in case of error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              print("Refresh gesture was tapped");
              setState(() {
                isLoading = true;
                getCurrentWeatherData(); // Fetch weather data again on refresh
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(), // Show progress indicator while loading
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // main content here...
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 20,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // degree text
                            Text(
                              "${weatherMain["temp"]} K",
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // cloud icons
                            const SizedBox(
                              height: 16,
                            ),
                            Icon(
                              currentSky["main"] == "Rain" ||
                                      currentSky["main"] == "Cloud"
                                  ? Icons.water_drop
                                  : Icons.cloud,
                              size: 68,
                            ),
                            // rain text
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              '${currentSky["main"]}',
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Weather Forecast",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (int i = 0; i < 5; i++)
                          ForecastBox(
                              '${(foreCastList[i]["dt_txt"]).toString().split(" ")[1]}',
                              "${foreCastList[i]["weather"][0]["main"]}",
                              "${foreCastList[i]["main"]["temp"]}"),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  // weather forecast card.
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Additional Forecast",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // humidity, wind_speed, pressure.
                  const SizedBox(
                    height: 18,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionalForeCast("Humidity",
                          '${weatherMain["humidity"]}', Icons.cloud),
                      AdditionalForeCast(
                          "Wind Speed", "${wind["speed"]}", Icons.wind_power),
                      AdditionalForeCast("Pressure",
                          '${weatherMain["pressure"]}', Icons.umbrella)
                    ],
                  )
                ],
              ),
            ),
    );
  }
}
