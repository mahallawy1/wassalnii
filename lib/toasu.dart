import 'package:flutter/material.dart';
//import 'package:firebase_firestore/firebase_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'payment.dart';
class ToastPage extends StatefulWidget {
  @override
  _ToastPageState createState() => _ToastPageState();
}

class _ToastPageState extends State<ToastPage> {
  final List<String> locations = ['Abbassia', 'Giza', 'Nasr', 'Tahrir', 'Hadaiq El Quba', 'Madenty', 'Moatam', 'Doky', 'Attaba', 'Tagamoaa'];
  String? selectedLocation;
  String? selectedGate;
  int? selectedSeats; // Variable for seat selection
  final List<int> seatNumbers = List.generate(10, (index) => index + 1); // Assuming a max of 10 seats can be reserved
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reserve a Ride"),
      ),
      body: Column(
          children: [

            Expanded(
              // Replace with an Image widget
              child: Image.asset('images/mapa.png',  // Ensure this matches the path to your image file
                fit: BoxFit.fill,  // This is to ensure the image covers the widget area, you can adjust as per your need
              ),
            ),
          DropdownButton<String>(
            hint: Text("Select Departure Location"),
            value: selectedLocation,
            onChanged: (newValue) {
              setState(() {
                selectedLocation = newValue!;
              });
            },
            items: locations.map((location) {
              return DropdownMenuItem(
                child: new Text(location),
                value: location,
              );
            }).toList(),
          ),
          DropdownButton<String>(
            hint: Text("Select Destination Gate"),
            value: selectedGate,
            onChanged: (newValue) {
              setState(() {
                selectedGate = newValue!;
              });
            },
            items: <String>['Gate 3 ASU', 'Gate 4 ASU'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
            DropdownButton<int>(
              hint: Text("Select Number of Seats"),
              value: selectedSeats,
              onChanged: (newValue) {
                setState(() {
                  selectedSeats = newValue!;
                });
              },
              items: seatNumbers.map((int seats) {
                return DropdownMenuItem<int>(
                  value: seats,
                  child: Text("$seats"),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: () {
                reserveRide();
              },
              child: Text("Reserve"),
            )
          ],
      ),
    );
  }


  void reserveRide() async {
    DateTime now = DateTime.now();
    DateTime cutoff = DateTime(now.year, now.month, now.day, 22);  // 10:00 PM cutoff
    if (selectedSeats == null) {
      // Ensure the user has selected the number of seats
      showErrorDialog("Please select the number of seats you want to reserve.");
      return;
    }
    if (!now.isAfter(cutoff)) {
      // It's too late to book for tomorrow's 7:30 AM ride
      showErrorDialog("It's too late to reserve a seat for tomorrow's 7:30 AM ride.");
      return;
    }

    if (selectedLocation == null || selectedGate == null) {
      // User needs to select both a location and a gate
      showErrorDialog("Please select both a departure location and a destination gate.");
      return;
    }

    // Get the current user's ID from Firebase Authentication
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      // No user is signed in
      showErrorDialog("You must be signed in to make a reservation.");
      return;
    }

    String userId = currentUser.uid;

    // Create a reservation in the user's subcollection
    await _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('reservations')
        .add({
      'departure': selectedLocation,
      'destination': selectedGate,
      'time': '7:30 AM',
      'price': 20 * selectedSeats!, // Assuming the price is per seat
      'date': DateTime.now().toString(),
      'seats': selectedSeats,
      'status': 'pending',// Include the number of seats reserved
    })
        .then((docRef) {
      // Navigate to the PaymentPage after successful reservation
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentPage(
            reservationId: docRef.id,
            price: 20 * selectedSeats!, // Assuming 20 is the price per seat
            destination: selectedGate!,
            departureGate: selectedGate!,
            time: '5:30 PM', // Or another variable if time is dynamic
            seats: selectedSeats!,
          ),
        ),
      );
    });

  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
        );
      },
    );
  }

  void showConfirmationDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
        );
      },
    );
  }
}
