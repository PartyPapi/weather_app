import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ralfs_weather/models/weather_model.dart';

import '../service/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
//api key
  final _weatherService = WeatherService('83b4c6cb278d423e0bebdcce9682c9eb');
  Weather? _weather;

//Wetterlage holen
  _fetchWeather() async {
    //hole aktuelle Stadt
    String cityName = await _weatherService.getCurrentCity();

    //hole Wetter für aktuelle Stadt
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }

    //hatten wir noch nicht, finde ich aber passend:
    //bei Fehlern...
    catch (e) {
      print(e);
    }
  }

//Wetteranimation
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

//initial State
  @override
  void initState() {
    super.initState();

    //hole Wetter beim Start
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 204, 88, 190),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Name der Stadt
            Text(_weather?.cityName ?? "loading city.."),

            //animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            //Temperatur
            Text('${_weather?.temperature.round()}°C'),

            //Wetterlage
            Text(_weather?.mainCondition ?? "")
          ],
        ),
      ),
    );
  }
}
