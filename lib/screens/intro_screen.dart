import 'package:flutter/material.dart';
import 'package:ubp/main.dart';
import 'package:ubp/screens/mobile_verify.dart';

import '../l10n/app_localizations.dart'; // To access MyApp.setLocale

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // LOGO
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: Image.asset(
                      'assets/bd_logo.png',
                      fit: BoxFit.contain,
                      //width: MediaQuery.of(context).size.width * 0.6,
                    ),
                  ),
                  const SizedBox(height: 50),

                  Text(
                    AppLocalizations.of(context)!.appProgramme,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  Text(
                    AppLocalizations.of(context)!.implementedBy,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black87,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // NEXT BUTTON
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MobileVerifyScreen(),
                          ),
                        );
                      },
                      child: Text(AppLocalizations.of(context)!.next),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
