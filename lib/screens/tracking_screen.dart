import 'package:flutter/material.dart';

class TrackingScreen extends StatelessWidget {
  final String name;
  final String applicationStatus;
  final String fatherName;
  final String factory;
  final String paymentStatus;
  final String mobile;
  final String token;

  const TrackingScreen({
    super.key,
    // required this.name,
    // required this.applicationStatus,
    // required this.fatherName,
    // required this.factory,
    // required this.paymentStatus,
    this.name = "N/A",
    this.applicationStatus = "Pending",
    this.fatherName = "N/A",
    this.factory = "Unknown",
    this.paymentStatus = "Unpaid",
    required this.mobile, 
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Application and Payment Tracking")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("This is a template. This feature has not yet been implemented due to lack of backend APIs", style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              Text("Name: $name", style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              Text("Father's Name: $fatherName",
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              Text("Factory: $factory",
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              Text("Application Status: $applicationStatus",
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              Text("Payment Status: $paymentStatus",
                  style: const TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}
