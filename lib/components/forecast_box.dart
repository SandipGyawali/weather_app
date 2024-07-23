import 'package:flutter/material.dart';

class ForecastBox extends StatelessWidget {
  final String time; //09:00
  final String icon;
  final String temperature;

  const ForecastBox(this.time, this.icon, this.temperature, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      // text
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              time,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Icon(icon == "Rain" || icon == "Cloud"
                ? Icons.water_drop
                : Icons.cloud),
            const SizedBox(
              height: 8,
            ),
            Text(temperature),
          ],
        ),
      ),
    );
  }
}
