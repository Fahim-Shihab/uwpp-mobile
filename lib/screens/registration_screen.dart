import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ubp/screens/details_personal_screen.dart';

import '../l10n/app_localizations.dart';
import '../main.dart';
import '../utils/constants.dart';
import 'error_screen.dart';
import 'waiting_screen.dart';

class RegistrationScreen extends StatefulWidget {
  final String mobile;
  final String token;

  const RegistrationScreen({
    super.key,
    required this.mobile,
    required this.token,
  });

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nidController = TextEditingController();
  final _nameController = TextEditingController();
  DateTime? _dob;

  // Validate NID: must be 10 or 17 digits
  String? _validateNID(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.errnid;
    }
    if (value.length != 10 && value.length != 17) {
      return AppLocalizations.of(context)!.errnid2;
    }
    return null;
  }

  String? _validateDoB(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.emptyDoB;
    }
    return null;
  }

  // There must be nameEn
  String? _validateNameEn(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.emptyNameEn;
    }
    return null;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _dob != null) {
      final url = Uri.parse("$actualBaseUrl/applicant/workforce-detail/get");
      final body = json.encode({
        "nid": _nidController.text,
        "nameEn": _nameController.text,
        "dob": DateFormat("yyyy-MM-dd").format(_dob!),
      });
      print("api body");
      print(body);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => WaitingScreen()),
      );
      final String token = widget.token;
      try {
        final response = await http.post(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: body,
        );

        final jsonResponse = json.decode(response.body);
        if (!mounted) return;
        if (response.statusCode == 200) {
          print("json Response:");
          print(jsonResponse);
          if (jsonResponse['success']) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => DetailsPersonalScreen(
                  mobile: widget.mobile,
                  nid: _nidController.text,
                  dob: DateFormat("yyyy-MM-dd").format(_dob!),
                  token: token,
                  resJson: jsonResponse,
                ),
              ),
            );
          } else {
            Navigator.pop(context);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(jsonResponse['message'])));
          }
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  ErrorScreen(mobile: widget.mobile, token: widget.token),
            ),
          );
        }
      } catch (e) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.registration),
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
                SizedBox(height: 20),
                TextFormField(
                  controller: _nidController,
                  keyboardType: TextInputType.number,
                  maxLength: 17,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.nidNum,
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: _validateNID,
                ),
                SizedBox(height: 10),
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.selectDob,
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  controller: TextEditingController(
                    text: _dob == null
                        ? ""
                        : DateFormat('yyyy-MM-dd').format(_dob!),
                  ),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2000),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() => _dob = picked);
                    }
                  },
                  validator: _validateDoB,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _nameController,
                  maxLength: 255,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.nameEn,
                  ),
                  validator: _validateNameEn,
                ),
                const SizedBox(height: 20),
                // Text(widget.token),
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
