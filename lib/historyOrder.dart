import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import intl package

class OrderHistoryPage extends StatefulWidget {
  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> _fetchFinishedReservations() {
    String userId = _auth.currentUser!.uid;
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('reservations')
        .where('status', isEqualTo: 'finished')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order History"),
        backgroundColor: Colors.purple.shade200, // Light purple theme
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(), // Back button
        ),
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/loo.jpg'), // Replace with your actual asset path
                fit: BoxFit.cover, // Cover the entire widget area
              ),
            ),
          ),
          // Content in a scrollable view
          SingleChildScrollView(
            child: StreamBuilder<QuerySnapshot>(
              stream: _fetchFinishedReservations(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No Finished Reservations Found"));
                }

                return Column(
                  children: snapshot.data!.docs.map((doc) {
                    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                    DateTime date;
                    try {
                      // Try to parse the date as a Timestamp first
                      date = (data['date'] as Timestamp).toDate();
                    } catch (_) {
                      try {
                        // If it's not a Timestamp, try parsing it as a String
                        date = DateTime.parse(data['date']);
                      } catch (_) {
                        // If parsing fails, use the current date or handle appropriately
                        date = DateTime.now();
                        // You might want to log this issue or handle it differently
                      }
                    }
                    String formattedDate = DateFormat('dd/MM/yyyy').format(date); // Format the date

                    return Card(
                      color: Colors.blue.shade200, // Card with very light purple color
                      child: ListTile(
                        title: Text("${data['destination']} - $formattedDate"),
                        subtitle: Text("Price: \$${data['price'].toString()}"),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
