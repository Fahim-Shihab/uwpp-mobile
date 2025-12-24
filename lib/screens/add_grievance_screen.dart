import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ubp/screens/intro_screen.dart';
import 'package:ubp/screens/tracking_screen.dart';
import 'package:ubp/screens/waiting_screen.dart';

import '../l10n/app_localizations.dart';
import '../main.dart';
import '../models/division.dart';
import '../utils/constants.dart';
import '../utils/form_utils.dart';

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
  final _nameEnController = TextEditingController();
  final _nidController = TextEditingController();
  DateTime? _dob;
  final _complaintController = TextEditingController();
  Division? _grievanceType;

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

  String? _validateInput(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.validInput;
    }
    return null;
  }

  // Example grievance types – you can replace with your backend values
  List<Division> grievanceTypes = [];

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  @override
  void dispose() {
    _complaintController.dispose();
    super.dispose();
  }

  Future<void> initializeData() async {
    await fetchGrievanceTypes();
  }

  Future<void> fetchGrievanceTypes() async {
    final url = Uri.parse("$actualBaseUrl/api/grievanceType/active");
    final String token = widget.token;

    print("url: " + url.toString());

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      }
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        grievanceTypes = data
            .map((json) => Division.fromJson(json))
            .toList();
      });
    }
  }

  Future<void> _submitGrievance() async {
    if (_formKey.currentState!.validate()) {
      final grievanceType = _grievanceType;
      final complaintText = _complaintController.text;

      print('Grievance Type: $grievanceType');
      print('Complaint Text: $complaintText');

      // TODO: Send to backend

      final body = json.encode({
        "mobileNumber": widget.mobile,
        "grievantName": _nameEnController.text,
        "nid": _nidController.text,
        "dob": DateFormat("yyyy-MM-dd").format(_dob!),
        "grievanceTypeId": _grievanceType!.id,
        "complain": _complaintController.text,
        "safetyNetProgram": "SPPDUW_MIS"
      });

      final uri = Uri.parse('$actualBaseUrl/grievance/lodgeByGrievant');

      Navigator.push(context, MaterialPageRoute(builder: (_) => WaitingScreen()));

      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${widget.token}",
        },
        body: body,
      );

      if (!mounted) return;
      Navigator.pop(context);

      if (response.statusCode == 200) {
        final respDecoded = jsonDecode(response.body);
        if (respDecoded["operationResult"] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.uploadSuccess),
              duration: Duration(seconds: 3),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  ApplicantDashboardScreen(
                    mobile: widget.mobile,
                    token: widget.token,
                  ),
            ),
          );
        } else {
          if (respDecoded["errorMsg"] != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(respDecoded["errorMsg"]),
                duration: Duration(seconds: 2),
              ),
            );
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.uploadFail)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.submitGriev),
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
                backgroundColor: Colors.lightBlue[100],
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
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameEnController,
                    decoration: InputDecoration(
                      label: buildRequiredLabel(
                        AppLocalizations.of(context)!.nameEn,
                      ),
                    ),
                    validator: _validateInput,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _nidController,
                    decoration: InputDecoration(
                      label: buildRequiredLabel(
                        AppLocalizations.of(context)!.nidNum,
                      ),
                    ),
                    validator: _validateNID,
                  ),
                  SizedBox(height: 20),
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
                  DropdownButtonFormField<Division>(
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.grievType,
                    ),
                    items: grievanceTypes.map((division) {
                      return DropdownMenuItem(
                        value: division,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Text(division.localizedName(context)),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _grievanceType = value;
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
