import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Map<String, dynamic>? _weatherData;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Map<String, Map<String, String>> dominicanCities = {
    'Santo Domingo': {'lat': '18.4861', 'lon': '-69.9312'},
    'Santiago': {'lat': '19.4511', 'lon': '-70.6970'},
    'La Romana': {'lat': '18.4273', 'lon': '-68.9728'},
  };

  Future<void> _fetchWeather() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var city = 'Santo Domingo'; // Cambia la ciudad según tu elección
      var apiUrl =
          'https://api.openweathermap.org/data/2.5/weather?lat=${dominicanCities[city]!['lat']}&lon=${dominicanCities[city]!['lon']}&appid=ad0ac9f99302579623e57e8adfd16318&units=metric&lang=es';
      var response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        setState(() {
          _weatherData = {
            'location': city,
            'temperature': data['main']['temp'].toString(),
            'description': data['weather'][0]['description'],
            'humidity': data['main']['humidity'],
            'wind_speed': data['wind']['speed'],
            'icon': 'sunny'
          };
        });
      } else {
        throw Exception('Error al cargar los datos de clima');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al obtener el clima')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clima en RD')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _weatherData != null
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _weatherData!['location'],
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          const Icon(Icons.wb_sunny,
                              size: 80, color: Colors.orange),
                          const SizedBox(height: 20),
                          Text(
                            '${_weatherData!['temperature']}°C',
                            style: const TextStyle(
                                fontSize: 48, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _weatherData!['description'],
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  const Icon(Icons.water_drop,
                                      color: Colors.blue),
                                  const Text('Humedad'),
                                  Text('${_weatherData!['humidity']}%'),
                                ],
                              ),
                              Column(
                                children: [
                                  const Icon(Icons.air, color: Colors.grey),
                                  const Text('Viento'),
                                  Text('${_weatherData!['wind_speed']} km/h'),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const Center(
                  child: Text('No se pudo obtener información del clima')),
    );
  }
}
