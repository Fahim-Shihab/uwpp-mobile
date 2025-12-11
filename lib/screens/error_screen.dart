import 'package:flutter/material.dart';
import 'package:ubp/screens/registration_screen.dart';

import '../l10n/app_localizations.dart';

class ErrorScreen extends StatelessWidget {
  final String mobile;
  final String token;

  const ErrorScreen({super.key, required this.mobile, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.credNotMatch),
              ElevatedButton(
                child: Text(AppLocalizations.of(context)!.backReg),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          RegistrationScreen(mobile: mobile, token: token),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
