import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReadyPage extends StatefulWidget {
  @override
  _ReadyPageState createState() => _ReadyPageState();
}

class _ReadyPageState extends State<ReadyPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getReadyTrips() {
    // Stream that listens to changes in the 'trips' collection where the status is 'ready'
    return _firestore.collection('trips')
        .where('status', isEqualTo: 'ready')
        .snapshots();
  }

  Future<void> _confirmTrip(String tripId, String userId) async {
    // Update the trip status to 'confirmed'
    await _firestore.collection('trips').doc(tripId).update({
      'status': 'confirmed'
    });

    // Move the trip to the user's subcollection
    DocumentSnapshot tripDoc = await _firestore.collection('trips').doc(tripId).get();
    if (tripDoc.exists) {
      Map<String, dynamic> tripData = tripDoc.data() as Map<String, dynamic>;
      await _firestore.collection('users').doc(userId).collection('reservations').doc(tripId).set(tripData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ready Trips"),
        backgroundColor: Colors.purple[500],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/loo.jpg'), // Replace with your actual asset path
            fit: BoxFit.cover, // Cover the entire widget area
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: getReadyTrips(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text("No Ready Trips"));
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot doc = snapshot.data!.docs[index];
                Map<String, dynamic> tripData = doc.data() as Map<String, dynamic>;

                return Card(
                  color: Colors.purple.shade50, // Card with light purple color
                  child: ListTile(
                    title: Text("Trip to ${tripData['destination']}"),
                    subtitle: Text("Driver: ${tripData['driverName']} - Car: ${tripData['carType']}"),
                    trailing: ElevatedButton(
                      onPressed: () => _confirmTrip(doc.id, _auth.currentUser!.uid),
                      child: Text('Confirm'),
                      style: ElevatedButton.styleFrom(primary: Colors.green),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
