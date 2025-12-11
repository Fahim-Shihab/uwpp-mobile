import 'package:flutter/material.dart';
import 'package:ubp/screens/intro_screen.dart';

import '../l10n/app_localizations.dart';

class AddGrievanceScreen extends StatefulWidget {
  final String mobile;
  final String token;

  const AddGrievanceScreen({
    super.key,
    required this.mobile,
    required this.token,
  });

  @override
  State<AddGrievanceScreen> createState() => _AddGrievanceScreenState();
}

class _AddGrievanceScreenState extends State<AddGrievanceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _complaintController = TextEditingController();

  String? selectedGrievanceType;

  // Example grievance types – you can replace with your backend values
  final List<String> grievanceTypes = [
    'Payment Not Received',
    'Applied but not selected',
    'Bank/MFS Issue',
    'Wrong Information',
    'Other',
  ];

  @override
  void dispose() {
    _complaintController.dispose();
    super.dispose();
  }

  void _submitGrievance() {
    if (_formKey.currentState!.validate()) {
      final grievanceType = selectedGrievanceType;
      final complaintText = _complaintController.text;

      print('Grievance Type: $grievanceType');
      print('Complaint Text: $complaintText');

      // TODO: Send to backend

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
        (route) => false, // removes all previous routes
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.submitGriev)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.grievType,
                    ),
                    value: selectedGrievanceType,
                    items: grievanceTypes.map((type) {
                      return DropdownMenuItem(value: type, child: Text(type));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGrievanceType = value;
                      });
                    },
                    validator: (value) => value == null
                        ? AppLocalizations.of(context)!.enterGrievType
                        : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _complaintController,
                    maxLines: 10,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.yourComplaint,
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppLocalizations.of(context)!.enterComplaint;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _submitGrievance,
                    child: Text(AppLocalizations.of(context)!.submit),
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
