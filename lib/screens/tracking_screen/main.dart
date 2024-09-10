import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'networking.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GoogleMapController mapController;

  final List<LatLng> polyPoints = []; // For holding coordinates as LatLng
  final Set<Polyline> polyLines = {}; // For holding instance of Polyline
  final Set<Marker> markers = {}; // For holding instance of Marker
  var data;

  // Dummy Start and Destination Points
  double startLat = 23.551904;
  double startLng = 90.532171;
  double endLat = 23.560625;
  double endLng = 90.531813;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setMarkers();
  }

  setMarkers() {
    markers.add(
      Marker(
        markerId: MarkerId("Home"),
        position: LatLng(startLat, startLng),
        infoWindow: InfoWindow(
          title: "Home",
          snippet: "Home Sweet Home",
        ),
      ),
    );

    markers.add(Marker(
      markerId: MarkerId("Destination"),
      position: LatLng(endLat, endLng),
      infoWindow: InfoWindow(
        title: "Destination",
        snippet: "5-star rated place",
      ),
    ));
    setState(() {});
  }

  void getJsonData() async {
    NetworkHelper network = NetworkHelper(
      startLat: startLat,
      startLng: startLng,
      endLat: endLat,
      endLng: endLng,
    );

    try {
      data = await network.getData();
      print("Response Data: $data"); // Debugging line to check response structure

      // Ensure data has expected keys
      if (data != null && data['features'] != null && data['features'].isNotEmpty) {
        List<dynamic> coordinates = data['features'][0]['geometry']['coordinates'];

        for (var point in coordinates) {
          polyPoints.add(LatLng(point[1], point[0])); // OpenRouteService returns [lng, lat]
        }

        if (polyPoints.isNotEmpty) {
          setPolyLines();
        } else {
          print("No polyline points received.");
        }
      } else {
        print("Invalid response structure or empty features.");
      }
    } catch (e) {
      print("Error: $e");
    }
  }


  setPolyLines() {
    Polyline polyline = Polyline(
      polylineId: PolylineId("polyline"),
      color: Colors.lightBlue,
      points: polyPoints,
      width: 5, // Set a width for visibility
    );

    polyLines.add(polyline);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getJsonData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Polyline Demo'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(startLat, startLng), // Start at the initial position
            zoom: 15,
          ),
          markers: markers,
          polylines: polyLines,
        ),
      ),
    );
  }
}

// Create a new class to hold the coordinates we've received from the response data
class LineString {
  LineString(this.lineString);
  List<dynamic> lineString;
}
