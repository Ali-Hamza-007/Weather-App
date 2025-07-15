import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/Keys.dart';
import 'package:weather_app/weather_forecasting.dart';
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {
  String? selectedCity = 'Lahore';
  late Future<Map<String, dynamic>> weatherFuture;

  @override
  void initState() {
    super.initState();
    weatherFuture = gettingDataFromSource();
  }

  // Use Your API Key to Run API , I had deactivated by API Key
  Future<Map<String, dynamic>> gettingDataFromSource() async {
    final result = await http.get(
      Uri.parse(
        'http://api.openweathermap.org/data/2.5/forecast?q=$selectedCity&APPID=$api_key',
      ),
    );

    final data = jsonDecode(result.body);

    if (data['cod'] != '200') {
     throw 'Internal Error Occurs / API Key Disabled';
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(23),
        child: Text(
          'Developed By Hamza </> ',
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
      ),
      appBar: AppBar(
        title: Text('Weather App'),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              setState(() {
                weatherFuture = gettingDataFromSource();
              });
            },
            child: Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: weatherFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final data = snapshot.data!;
          final list = data['list'];

          // Get today's main info
          double temp = double.parse(list[0]['main']['temp'].toString()) - 273;
          String temprature = '${temp.toStringAsFixed(0)} °C';
          String weather = list[0]['weather'][0]['main'];
          String humidity = list[0]['main']['humidity'].toString();
          String pressure = list[0]['main']['pressure'].toString();
          String windSpeed = list[0]['wind']['speed'].toString();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButton<String>(
                    elevation: 0,
                    hint: Text('Select City ( Default Lahore )'),
                    value: selectedCity,
                    items:
                        [
                              'Multan',
                              'London',
                              'Jaranwala',
                              'Islamabad',
                              'Karachi',
                              'Lahore',
                            ]
                            .map(
                              (city) => DropdownMenuItem(
                                value: city,
                                child: Text(city),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedCity = value;
                          weatherFuture = gettingDataFromSource();
                        });
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 230,
                    width: double.infinity,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            temprature,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          (weather == 'Clouds' || weather == 'Rain')
                              ? Icon(Icons.cloud, size: 64)
                              : Icon(Icons.sunny, size: 64),
                          SizedBox(height: 10),
                          Text(
                            weather,
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Weather Forecasting',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(5, (index) {
                        final item = list[index + 1];
                        final time = item['dt_txt'];
                        final dateTime = DateTime.parse(time);
                        final weather = item['weather'][0]['main'];
                        return WeatherForecastingItems(
                          time: DateFormat.j().format(dateTime),
                          weather: weather,
                        );
                      }),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Additional Information',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Icon(Icons.water_drop, size: 40),
                          SizedBox(height: 12),
                          Text(
                            'Humidity',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          SizedBox(height: 12),
                          Text(
                            humidity,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.air, size: 40),
                          SizedBox(height: 12),
                          Text(
                            'Wind Speed',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          SizedBox(height: 12),
                          Text(
                            windSpeed,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.beach_access, size: 40),
                          SizedBox(height: 12),
                          Text(
                            'Pressure',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          SizedBox(height: 12),
                          Text(
                            pressure,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
