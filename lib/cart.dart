import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> _fetchReservations() {
    String userId = _auth.currentUser!.uid;
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('reservations')
        .where('status', whereIn: ['pending', 'confirmed'])
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Reservations"),
        backgroundColor: Colors.purple.withOpacity(0.7), // Purple theme with some transparency
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
                image: AssetImage('images/moo.jpg'), // Replace with your actual asset path
                fit: BoxFit.cover, // Cover the entire widget area
              ),
            ),
          ),
          // Your existing content in a scrollable view
          SingleChildScrollView(
            child: StreamBuilder<QuerySnapshot>(
              stream: _fetchReservations(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No Reservations Found"));
                }

                return Column(
                  children: snapshot.data!.docs.map((doc) {
                    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                    return Card(
                      color: Colors.green.shade400, // Card with light purple color
                      child: ListTile(
                        title: Text("${data['destination']} - ${data['time']}"),
                        subtitle: Text("Status: ${data['status']}\nPrice: \$${data['price'].toString()}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Only show the finish button if the status is 'confirmed'
                            if (data['status'] == 'confirmed')
                              IconButton(
                                icon: Icon(Icons.check_circle, color: Colors.green),
                                onPressed: () => _updateReservationStatus(doc.id, 'finished'),
                              ),
                            IconButton(
                              icon: Icon(Icons.cancel, color: Colors.red),
                              onPressed: () => _updateReservationStatus(doc.id, 'canceled'),
                            ),
                          ],
                        ),
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

  void _updateReservationStatus(String reservationId, String newStatus) {
    String userId = _auth.currentUser!.uid;
    _firestore
        .collection('users')
        .doc(userId)
        .collection('reservations')
        .doc(reservationId)
        .update({'status': newStatus})
        .then((_) => print("Reservation updated"))
        .catchError((error) => print("Failed to update reservation: $error"));
  }
}
