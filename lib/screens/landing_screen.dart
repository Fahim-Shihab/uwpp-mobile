import 'package:flutter/material.dart';
import 'package:ubp/screens/add_grievance_screen.dart';
import 'package:ubp/screens/registration_screen.dart';

import '../l10n/app_localizations.dart';
import '../main.dart';

class LandingScreen extends StatelessWidget {
  final String mobile;
  final String token;

  const LandingScreen({super.key, required this.mobile, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.selectOption),
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
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SELF-REGISTRATION BUTTON
              SizedBox(
                width: double.infinity,
                height: 70,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            RegistrationScreen(mobile: mobile, token: token),
                      ),
                    );
                  },
                  icon: const Icon(Icons.app_registration, size: 28),
                  label: Text(
                    AppLocalizations.of(context)!.selfRegistration,
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 34),

              // GRIEVANCE SUBMISSION BUTTON
              SizedBox(
                width: double.infinity,
                height: 70,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            AddGrievanceScreen(mobile: mobile, token: token),
                      ),
                    );
                  },
                  icon: const Icon(Icons.feedback, size: 28),
                  label: Text(
                    AppLocalizations.of(context)!.grievanceSubmission,
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
