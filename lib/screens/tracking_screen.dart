import 'package:flutter/material.dart';

class TrackingScreen extends StatelessWidget {
  final String mobile;
  final String token;

  const TrackingScreen({
    super.key,
    required this.mobile,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Applicant Dashboard")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "This is a template. This feature has not yet been implemented due to lack of backend APIs",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
