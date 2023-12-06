import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'cartpage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carpool Routes',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MapsPage(),
    );
  }
}

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  GoogleMapController? mapController;

  final LatLng _center = const LatLng(30.0595581, 31.2233591); // Centered at Ain Shams University

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Routes to Ain Shams Campus'),
        backgroundColor: Colors.purple[500],
      ),
      body: Image.asset('images/mapo.png'),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartPage(/*route: routes[index]*/)),
          );
        },
        backgroundColor: Colors.purple,
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}

/* GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        // Add more map properties and functionalities as needed
      ),*/