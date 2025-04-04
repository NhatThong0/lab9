import 'package:flutter/material.dart';

class WeatherDisplay extends StatelessWidget {
  final String city;
  final String weather;
  final double temperature;
  final String time;
  final String timezone;

  const WeatherDisplay({
    super.key,
    required this.city,
    required this.weather,
    required this.temperature,
    required this.time,
    required this.timezone,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              city.isNotEmpty ? city : 'No City Selected',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              weather.isNotEmpty ? weather : 'No Weather Data',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 10),
            Text(
              temperature != 0.0
                  ? '${temperature.toStringAsFixed(1)}°C'
                  : 'No Temperature Data',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              time.isNotEmpty ? 'Time: $time' : 'No Time Data',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 5),
            Text(
              timezone.isNotEmpty ? 'Timezone: $timezone' : 'No Timezone Data',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
