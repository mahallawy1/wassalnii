import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'cartpage.dart';

import 'toasu.dart';
import 'fromasu.dart';
import 'cart.dart';
import 'historyOrder.dart';  // Assuming you have this page
import 'profile.dart';
import 'ready.dart';// Assuming you have this page



class Route {
  final String id;
  final String startPoint;
  final String endPoint;
  final String time;

  Route({required this.id, required this.startPoint, required this.endPoint, required this.time});
}

class RoutesPage extends StatelessWidget {
  final List<Route> routes = [
    Route(id: '1', startPoint: 'Various Locations', endPoint: 'Gate 3 and 4 of Ain Shams Faculty of Engineering', time: '7:30 AM'),
    Route(id: '2', startPoint: 'Gate 3 and 4 of Ain Shams Faculty of Engineering', endPoint: 'Various Locations', time: '5:30 PM'),
  ];

  @override
  Widget build(BuildContext context) {
    // Fetch the current user
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Ain Shams Campus Routes'),
        backgroundColor: Colors.purple[500],
        actions: [
          // Order History Button
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrderHistoryPage()),
              );
            },
          ),
          // Cart Page Button
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/hoo.jpg'), // Replace with your actual asset path
                fit: BoxFit.cover, // Cover the entire widget area
              ),
            ),
          ),
          Column(
            children: [
              // User Profile and Welcome Message
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('images/poo.jpg'), // Replace with your actual asset path
                      radius: 30.0,
                    ),
                    SizedBox(height: 8),
                    OutlinedButton(
                      child: Text('View Profile'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfilePage()), // Assuming you have this page
                        );
                      },
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Welcome back ${user?.displayName ?? 'User'}!!',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
    GestureDetector(

    onTap: () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ReadyPage()), // Navigate to ReadyPage
    );
    },
      child: Image.asset(
        'images/ready_02.gif',
        // Replace with your actual asset path
        fit: BoxFit.scaleDown,
        width: 100, // Set the desired width
        height: 100,
        // Set the desired height
      ),
    ),

                  ],
                ),
              ),
              // Expanded widget to push the list to the bottom
              Expanded(child: Container()),
              // Routes List
              ListView.builder(
                shrinkWrap: true,  // Use shrinkWrap to limit the ListView's size to its content
                itemCount: routes.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      onTap: () {
                        if (index == 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ToastPage()),
                          );
                        } else if (index == 1) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FromAsuPage()),
                          );
                        }
                      },
                      title: Text('Route: ${routes[index].startPoint} to ${routes[index].endPoint}'),
                      subtitle: Text('Departure at: ${routes[index].time}'),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
