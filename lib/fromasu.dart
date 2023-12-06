import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'payment.dart';
class FromAsuPage extends StatefulWidget {
  @override
  _FromAsuPageState createState() => _FromAsuPageState();
}

class _FromAsuPageState extends State<FromAsuPage> {
  final List<String> destinations = [
    'Abbassia',
    'Giza',
    'Nasr',
    'Tahrir',
    'Hadaiq El Quba',
    'Madenty',
    'Moatam',
    'Doky',
    'Attaba',
    'Tagamoaa',
  ];
  String? selectedDestination;
  String? selectedGate;
  int? selectedSeats;
  final List<int> seatNumbers = List.generate(10, (index) => index + 1);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reserve a Ride from ASU"),
      ),
      body: Column(
        children: [
          Expanded(
            // Replace with an Image widget
            child: Image.asset('images/mapa.png',  // Ensure this matches the path to your image file
              fit: BoxFit.cover,  // This is to ensure the image covers the widget area, you can adjust as per your need
            ),
          ),
          DropdownButton<String>(
            hint: Text("Select Destination"),
            value: selectedDestination,
            onChanged: (newValue) {
              setState(() {
                selectedDestination = newValue!;
              });
            },
            items: destinations.map((destination) {
              return DropdownMenuItem(
                child: Text(destination),
                value: destination,
              );
            }).toList(),
          ),
          DropdownButton<String>(
            hint: Text("Select Departure Gate"),
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
    DateTime cutoff = DateTime(now.year, now.month, now.day, 13);  // 1:00 PM cutoff for same day 5:30 PM ride

    if (now.isAfter(cutoff)) {
      showErrorDialog("It's too late to reserve a seat for today's 5:30 PM ride.");
      return;
    }

    if (selectedDestination == null || selectedGate == null || selectedSeats == null) {
      showErrorDialog("Please select a destination, departure gate, and the number of seats.");
      return;
    }

    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (userId.isEmpty) {
      showErrorDialog("You must be signed in to make a reservation.");
      return;
    }

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('reservations')
        .add({
      'destination': selectedDestination,
      'departureGate': selectedGate,
      'time': '5:30 PM',
      'price': 20 * selectedSeats!,
      'date': now.toString(),
      'seats': selectedSeats,
      'status': 'pending',
    })
        .then((docRef) {
      // Navigate to the PaymentPage after successful reservation
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentPage(
            reservationId: docRef.id,
            price: 20 * selectedSeats!, // Assuming 20 is the price per seat
            destination: selectedDestination!,
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
