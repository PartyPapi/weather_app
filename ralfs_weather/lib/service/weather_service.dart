import 'dart:convert';

import "package:geocoding/geocoding.dart";
import "package:geolocator/geolocator.dart";

import '../models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = 'http://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http
        .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Ach komm, ich konnte keine Daten bekommen. Mist!');
    }
  }

//Abfrageerlaubnis des aktuellen Standortes einholen
  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    //Aktuellen Standort holen.
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    //Location aus Namen zu Koordinaten konvertieren
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    //Stadt aus der ersten Markierung extrahieren
    String? city = placemarks[0].locality;

    return city ?? "";
  }
}
