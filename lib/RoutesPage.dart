import 'package:flutter/material.dart';
import 'cartpage.dart';
import 'maproute.dart';
void main() => runApp(MyApp());
class Route {
  final String id;
  final String startPoint;
  final String endPoint;
  final String time;

  Route({required this.id, required this.startPoint, required this.endPoint, required this.time});
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carpool Routes',
      home: RoutesPage(),
    );
  }
}

class RoutesPage extends StatelessWidget {
  final List<Route> routes = [
    Route(id: '1', startPoint: 'Location A', endPoint: 'Ain Shams Campus', time: '08:00 AM'),
    Route(id: '2', startPoint: 'Location B', endPoint: 'Ain Shams Campus', time: '08:30 AM'),
    // Add more routes here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ain Shams Campus Routes'),

        backgroundColor: Colors.purple[500],


      ),

      body: ListView.builder(
        itemCount: routes.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              onTap: () {
                // Perform action on tap, e.g., navigate to a new screen with route details
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapsPage(/*route: routes[index]*/)),
                );
              },
              title: Text('from ${routes[index].startPoint} to ${routes[index].endPoint}'),
              subtitle: Text('Departure at: ${routes[index].time}'),
              // Add more details if needed
            ),
          );
        },
      ),
    );
  }
}