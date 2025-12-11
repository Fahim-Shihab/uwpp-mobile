import 'package:flutter/material.dart';
import 'package:ubp/screens/mobile_verify.dart';

import '../l10n/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    try {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MobileVerifyScreen()),
      );
    } catch (e) {
      setState(() {
        errorMessage = AppLocalizations.of(context)!.cantConnect;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: errorMessage != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(errorMessage!),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() => errorMessage = null);
                        initialize();
                      },
                      child: Text(AppLocalizations.of(context)!.retry),
                    ),
                  ],
                )
              : CircularProgressIndicator(),
        ),
      ),
    );
  }
}
