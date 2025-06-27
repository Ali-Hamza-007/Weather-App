import 'package:flutter/material.dart';

class WeatherForecastingItems extends StatelessWidget {
  final String time;
  final String weather;

  const WeatherForecastingItems({
    super.key,
    required this.time,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Text(
                time,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              (weather == 'Clouds' || weather == 'Rain')
                  ? Icon(Icons.cloud, size: 60, color: Colors.white)
                  : Icon(Icons.sunny, size: 60, color: Colors.white),
              SizedBox(height: 10),
              Text(
                weather,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
