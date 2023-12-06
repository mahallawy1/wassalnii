
import 'package:flutter/material.dart';
//import 'package:firebase_firestore/firebase_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'toast.dart';
  class PaymentPage extends StatefulWidget {
  final String reservationId;
  final int price;
  final String destination;
  final String departureGate;
  final String time;
  final int seats;

  PaymentPage({
  required this.reservationId,
  required this.price,
  required this.destination,
  required this.departureGate,
  required this.time,
  required this.seats,
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
  }

  class _PaymentPageState extends State<PaymentPage> {
  String? selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  appBar: AppBar(
  title: Text("Complete Payment"),
  ),
  body: Column(
  children: [
    ListTile(
      title: Text("Cash"),
      leading: Radio(
        value: "Cash",
        groupValue: selectedPaymentMethod,
        onChanged: (value) {
          setState(() {
            selectedPaymentMethod = value as String?;
          });
        },
      ),
    ),
    ListTile(
      title: Text("Credit"),
      leading: Radio(
        value: "Credit",
        groupValue: selectedPaymentMethod,
        onChanged: (value) {
          setState(() {
            selectedPaymentMethod = value as String?;
          });
        },
      ),
    ),
  // Display trip and price details
  ListTile(
  title: Text("Trip Details"),
  subtitle: Text(
  "${widget.destination} from ${widget.departureGate} at ${widget.time} for ${widget.seats} seats. Total: \$${widget.price}",
  ),
  ),
  // ... existing payment method widgets ...
  ElevatedButton(
  onPressed: selectedPaymentMethod == null ? null : () => confirmReservation(),
  child: Text("Confirm Reservation"),
  ),
  ],
  ),
  );
  }

    void confirmReservation() {
      if (selectedPaymentMethod != null) {
        // User confirms payment method, reservation remains 'pending'
        Navigator.pop(context);
        showToast(message: "trip paid and pending");
        // Optionally, return to the previous screen
        // You might also want to show a message to the user that their reservation is pending confirmation
      }
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