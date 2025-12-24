import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:ubp/screens/landing_screen.dart';
import 'package:ubp/screens/mobile_verify.dart';
import 'package:ubp/screens/tracking_screen.dart';

import '../l10n/app_localizations.dart';
import '../utils/constants.dart';

class OtpScreen extends StatefulWidget {
  final String mobile;

  const OtpScreen({super.key, required this.mobile});

  @override
  OtpScreenState createState() => OtpScreenState();
}

class OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();
  late Timer _timer;
  int _timeRemaining = 300;
  String token = "";

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeRemaining == 0) {
        timer.cancel();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MobileVerifyScreen()),
        );
      } else {
        setState(() {
          _timeRemaining--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _otpController.dispose();
    super.dispose();
  }

  String? _validateOTP(String? value) {
    if (value == null || value.isEmpty)
      return AppLocalizations.of(context)!.errotp;
    if (value.length != 6) {
      return AppLocalizations.of(context)!.errotp2;
    }
    return null;
  }

  Future<void> _submitOTP() async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Expanded(child: Text(AppLocalizations.of(context)!.otpVerifying)),
          ],
        ),
      ),
    );

    final url = Uri.parse(
      "$actualBaseUrl/applicant/self-registration/verify-otp",
    );

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "mobileNumber": widget.mobile,
          "otp": _otpController.text,
        }),
      );

      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog

      final res = json.decode(response.body);

      print("OTP Response:");
      print(res);
      print('Token saved: ${res["token"]}');

      if (response.statusCode == 200) {
        //TODO: only success == true
        if (res["success"] == true) {
          if (res["existingApplicant"] ==  true) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ApplicantDashboardScreen(
                      mobile: widget.mobile,
                      token: res["token"],
                    ),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    LandingScreen(
                      mobile: widget.mobile,
                      token: res["token"],
                    ),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.invalidOtp)),
          );
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Server error.")));
      }
    } catch (e) {
      Navigator.pop(context); // Ensure loading dialog closes on error
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Something went wrong.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (_timeRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_timeRemaining % 60).toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.errotp)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 150),
              Text(AppLocalizations.of(context)!.enterOTP),
              const SizedBox(height: 10),
              Text(widget.mobile),
              const SizedBox(height: 20),
              Text("${AppLocalizations.of(context)!.timeRem}$minutes:$seconds"),
              const SizedBox(height: 20),
              TextFormField(
                controller: _otpController,
                maxLength: 6,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.errotp,
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: _validateOTP,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitOTP,
                child: Text(AppLocalizations.of(context)!.submit),
              ),
              // Text(widget.token)
            ],
          ),
        ),
      ),
    );
  }
}
