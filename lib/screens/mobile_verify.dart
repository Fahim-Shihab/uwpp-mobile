import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../l10n/app_localizations.dart';
import '../main.dart';
import '../utils/constants.dart';
import 'otp_screen.dart';
import 'waiting_screen.dart';

class MobileVerifyScreen extends StatefulWidget {
  const MobileVerifyScreen({super.key});

  @override
  State<MobileVerifyScreen> createState() => _MobileVerifyScreenState();
}

class _MobileVerifyScreenState extends State<MobileVerifyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();

  // Validate mobile: must be 11 digits, starts with 01
  String? _validateMobile(String? value) {
    if (value == null || value.isEmpty)
      return AppLocalizations.of(context)!.errmob;
    if (!RegExp(r'^01\d{9}$').hasMatch(value)) {
      return AppLocalizations.of(context)!.errmob2;
    }
    return null;
  }

  bool isWithinWorkingHours([DateTime? dateTime]) {
    final now = dateTime ?? DateTime.now();

    const allowedDays = {
      DateTime.sunday,
      DateTime.monday,
      DateTime.tuesday,
      DateTime.wednesday,
      DateTime.thursday
    };

    if (!allowedDays.contains(now.weekday)) return false;

    final start = DateTime(now.year, now.month, now.day, 9);
    final end = DateTime(now.year, now.month, now.day, 17);

    return now.isAfter(start) && now.isBefore(end);
  }

  Future<void> _submitForm() async {
    if (!isWithinWorkingHours(DateTime.now())) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.activeOfficeHours)));
      return;
    }
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse(
        "$actualBaseUrl/applicant/self-registration/request-otp",
      );
      final body = json.encode({"mobileNumber": _mobileController.text});

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => WaitingScreen()),
      );

      try {
        final response = await http.post(
          url,
          headers: {
            "Content-Type": "application/json",
            //"Authorization": "Bearer $token",
          },
          body: body,
        );

        Navigator.pop(context);
        print("Received response: ${response.statusCode} at ${DateTime.now()}");
        print("The response body is" + response.body);
        final jsonResponse = json.decode(response.body);
        if (!mounted) return;

        // if (jsonResponse != null) {
        //   ScaffoldMessenger.of(
        //     context,
        //   ).showSnackBar(SnackBar(content: Text(jsonResponse.toString())));
        // }

        if (response.statusCode == 200 && jsonResponse['success'] == true) {
          print('Status: ');
          print(jsonResponse['success']);
          print('Message: ');
          print(jsonResponse['message']);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => OtpScreen(mobile: _mobileController.text),
            ),
          );
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(jsonResponse['message'])));
        }
      } catch (e) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${AppLocalizations.of(context)!.errorRequestingOtp}\n$e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.login),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ElevatedButton(
              onPressed: () {
                Locale current = Localizations.localeOf(context);
                Locale newLocale = current.languageCode == 'en'
                    ? Locale('bn')
                    : Locale('en');
                MyApp.setLocale(context, newLocale);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue[100], // Light blue background
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.languageToggleButton,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 250),
                TextFormField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  maxLength: 11,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.mobNum,
                    labelStyle: TextStyle(fontSize: 20),
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: _validateMobile,
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(AppLocalizations.of(context)!.submit),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
