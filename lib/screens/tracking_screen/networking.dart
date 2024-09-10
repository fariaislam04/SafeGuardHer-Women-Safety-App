import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  NetworkHelper({
    required this.startLng,
    required this.startLat,
    required this.endLng,
    required this.endLat,
  });

  final String url = 'https://api.openrouteservice.org/v2/directions/';
  final String apiKey = 'AIzaSyAjzLeP9dxZz4cgw2EJnFFHwErtSFjLQV0'; // Replace with your OpenRouteService API key
  final String journeyMode = 'driving-car'; // Change it if you want or make it variable
  final double startLng;
  final double startLat;
  final double endLng;
  final double endLat;

  Future getData() async {
    final response = await http.get(
      Uri.parse('$url$journeyMode?api_key=$apiKey&start=$startLng,$startLat&end=$endLng,$endLat'),
    );

    print("$url$journeyMode?api_key=$apiKey&start=$startLng,$startLat&end=$endLng,$endLat");

    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print("Error: ${response.statusCode}");
    }
  }
}
