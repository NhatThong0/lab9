import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'weather_display.dart'; // Import widget hiển thị thời tiết

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String _city = '';
  String _weather = 'Unknown';
  double _temperature = 0.0;
  String _time = '';
  String _timezone = '';

  final TextEditingController _cityController = TextEditingController();

  Future<void> _fetchWeather(String city) async {
    const apiKey =
        '29b34bc5b5d7e71ccef1b9c943612f85'; // Thay bằng API key của bạn
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final int timezoneOffset =
            data['timezone']; // Lấy múi giờ (giây lệch so với UTC)
        final DateTime now = DateTime.now().toUtc().add(
          Duration(seconds: timezoneOffset),
        );

        setState(() {
          _city = data['name'];
          _weather = data['weather'][0]['description'];
          _temperature = data['main']['temp'];
          _timezone =
              'UTC${timezoneOffset ~/ 3600 >= 0 ? '+' : ''}${timezoneOffset ~/ 3600}';
          _time =
              '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
        });
      } else {
        setState(() {
          _weather = 'City not found';
        });
      }
    } catch (e) {
      setState(() {
        _weather = 'Error fetching weather';
      });
    }
  }

  Future<void> _fetchWeatherByLocation() async {
    const apiKey =
        '29b34bc5b5d7e71ccef1b9c943612f85'; // Thay bằng API key của bạn
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&units=metric',
      );

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final int timezoneOffset =
            data['timezone']; // Lấy múi giờ (giây lệch so với UTC)
        final DateTime now = DateTime.now().toUtc().add(
          Duration(seconds: timezoneOffset),
        );

        setState(() {
          _city = data['name'];
          _weather = data['weather'][0]['description'];
          _temperature = data['main']['temp'];
          _timezone =
              'UTC${timezoneOffset ~/ 3600 >= 0 ? '+' : ''}${timezoneOffset ~/ 3600}';
          _time =
              '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
        });
      } else {
        setState(() {
          _weather = 'Location not found';
        });
      }
    } catch (e) {
      setState(() {
        _weather = 'Error fetching location';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather App'), centerTitle: true),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://i.pinimg.com/474x/14/d5/d8/14d5d8151c7b8e3d5d4f247cefdd597a.jpg',
            ),
            fit: BoxFit.cover, // Để hình ảnh phủ toàn bộ màn hình
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WeatherDisplay(
                city: _city,
                weather: _weather,
                temperature: _temperature,
                time: _time,
                timezone: _timezone,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: 'Enter city name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.location_city),
                  filled: true, // Để làm nền TextField mờ
                  fillColor: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      _fetchWeather(_cityController.text);
                    },
                    icon: const Icon(Icons.search),
                    label: const Text('Get Weather'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _fetchWeatherByLocation,
                    icon: const Icon(Icons.my_location),
                    label: const Text('By Location'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
