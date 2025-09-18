import 'package:flutter/material.dart';
import 'package:ubp/screens/details_work_screen.dart';
import '../l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../main.dart';
import '../utils/constants.dart';
import '../models/division.dart';
import '../models/district.dart';
import '../models/upazila.dart';
import 'package:collection/collection.dart';

import '../utils/form_utils.dart';

class DetailsAddressScreen extends StatefulWidget {
  final String token;
  final Map<String, dynamic> resJson;
  final Map<String, dynamic> userJson;

  const DetailsAddressScreen({super.key, required this.token, required this.resJson, required this.userJson });

  @override
  DetailsAddressScreenState createState() => DetailsAddressScreenState();
}

class DetailsAddressScreenState extends State<DetailsAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  String token = "";

  // Controllers
  Division? _presentDivision;
  District? _presentDistrict;
  Upazila? _presentUpazila;
  Division? _permanentDivision;
  District? _permanentDistrict;
  Upazila? _permanentUpazila;

  List<Division> divisions = [];
  List<District> presentDistricts = [];
  List<District> permanentDistricts = [];
  List<Upazila> presentUpazilas = [];
  List<Upazila> permanentUpazilas = [];

  @override
  void initState() {
    super.initState();
    token = widget.token;
    print(widget.userJson);
    //print(mockResponseJson);
    initializeData();
  }

  Future<void> initializeData() async {
    await fetchDivisions();

    final lims = widget.resJson['limsResponse'];

    // Present Address
    final present = lims?['presentAddress'] as Map<String, dynamic>?;
    final String? presentDivisionCode = present?['divisionCode'];
    final String? presentDistrictCode = present?['districtCode'];
    final String? presentUpazilaCode = present?['upazilaCode'];

    _presentDivision = divisions.firstWhereOrNull((d) => d.id.toString() == presentDivisionCode);
    if (_presentDivision != null) {
      await fetchPresentDistricts(_presentDivision!.id);
      _presentDistrict = presentDistricts.firstWhereOrNull((d) => d.id.toString() == presentDistrictCode);
      if (_presentDistrict != null) {
        await fetchPresentUpazilas(_presentDistrict!.id);
        _presentUpazila = presentUpazilas.firstWhereOrNull((u) => u.id.toString() == presentUpazilaCode);
      }
    }

    // Permanent Address
    final permanent = lims?['permanentAddress'] as Map<String, dynamic>?;
    final String? permanentDivisionCode = permanent?['divisionCode'];
    final String? permanentDistrictCode = permanent?['districtCode'];
    final String? permanentUpazilaCode = permanent?['upazilaCode'];

    _permanentDivision = divisions.firstWhereOrNull((d) => d.id.toString() == permanentDivisionCode);
    if (_permanentDivision != null) {
      await fetchPermanentDistricts(_permanentDivision!.id);
      _permanentDistrict = permanentDistricts.firstWhereOrNull((d) => d.id.toString() == permanentDistrictCode);
      if (_permanentDistrict != null) {
        await fetchPermanentUpazilas(_permanentDistrict!.id);
        _permanentUpazila = permanentUpazilas.firstWhereOrNull((u) => u.id.toString() == permanentUpazilaCode);
      }
    }

    setState(() {});
  }

  bool isFieldDisabled(TextEditingController controller) => controller.text.isNotEmpty;


  Future<void> fetchDivisions() async {
    final response = await http.get(
      Uri.parse('$actualBaseUrl/lookup/division/get'),
      headers: {
        'Accept': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        divisions = data.map((json) => Division.fromJson(json)).toList();
      });
    } else {
      // Handle error
    }
  }

  Future<void> _submitDetails() async {
    if (_presentDivision == null || _presentDistrict == null || _presentUpazila == null || _permanentDivision == null || _permanentDistrict == null || _permanentUpazila == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.fillFields)));
      return;
    }
    widget.userJson["division"] = _presentDivision!.id;
    widget.userJson["district"] = _presentDistrict!.id;
    widget.userJson["upazila"] = _presentUpazila!.id;
    widget.userJson["permanentDivisionId"] = _permanentDivision!.id;
    widget.userJson["permanentDistrictId"] = _permanentDistrict!.id;
    widget.userJson["permanentUpazilaId"] = _permanentUpazila!.id;

    // ✅ Navigate to banking page with this JSON
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailsWorkScreen(
          token: token,
          userJson: widget.userJson,
          resJson: widget.resJson,
        ),
      ),
    );
  }

  Future<void> fetchPresentDistricts(int id) async {
    final response = await http.get(
      Uri.parse('$actualBaseUrl/lookup/district/get?divisionId=$id'),
      headers: {
        'Accept': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        presentDistricts = data.map((json) => District.fromJson(json)).toList();
        _presentDistrict = null;
        presentUpazilas = [];
        _presentUpazila = null;
      });
    }
  }

  Future<void> fetchPermanentDistricts(int id) async {
    final response = await http.get(
      Uri.parse('$actualBaseUrl/lookup/district/get?divisionId=$id'),
      headers: {
        'Accept': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        permanentDistricts = data.map((json) => District.fromJson(json)).toList();
        _permanentDistrict = null;
        permanentUpazilas = [];
        _permanentUpazila = null;
      });
    }
  }

  Future<void> fetchPresentUpazilas(int id) async {
    final response = await http.get(
      Uri.parse('$actualBaseUrl/lookup/upazila/get?districtId=$id'),
      headers: {
        'Accept': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        presentUpazilas = data.map((json) => Upazila.fromJson(json)).toList();
        _presentUpazila = null;
      });
    }
  }


  Future<void> fetchPermanentUpazilas(int id) async {
    final response = await http.get(
      Uri.parse('$actualBaseUrl/lookup/upazila/get?districtId=$id'),
      headers: {
        'Accept': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        permanentUpazilas = data.map((json) => Upazila.fromJson(json)).toList();
        _permanentUpazila = null;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.detailsForm),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ElevatedButton(
              onPressed: () {
                Locale current = Localizations.localeOf(context);
                Locale newLocale = current.languageCode == 'en' ? Locale('bn') : Locale('en');
                MyApp.setLocale(context, newLocale);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue[100], // Light blue background
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.languageToggleButton,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(AppLocalizations.of(context)!.presentAddress, style: TextStyle(fontWeight: FontWeight.bold)),
                DropdownButtonFormField<Division>(
                  decoration: InputDecoration(label: buildRequiredLabel(AppLocalizations.of(context)!.division)),
                  value: _presentDivision,
                  items: divisions.map((division) {
                    return DropdownMenuItem(value: division, child: SizedBox(width: MediaQuery.of(context).size.width * 0.8, child: Text(division.localizedName(context))));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _presentDivision = value;
                      _presentDistrict = null;
                      _presentUpazila = null;
                    });
                    fetchPresentDistricts(value!.id);
                  },
                ),
                DropdownButtonFormField<District>(
                  decoration: InputDecoration(label: buildRequiredLabel(AppLocalizations.of(context)!.district)),
                  value: _presentDistrict,
                  items: presentDistricts.map((district) {
                    return DropdownMenuItem(value: district, child: SizedBox(width: MediaQuery.of(context).size.width * 0.8, child: Text(district.localizedName(context))));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _presentDistrict = value;
                      _presentUpazila = null;
                    });
                    fetchPresentUpazilas(value!.id);
                  },
                ),
                DropdownButtonFormField<Upazila>(
                  decoration: InputDecoration(label: buildRequiredLabel(AppLocalizations.of(context)!.upazila)),
                  value: _presentUpazila,
                  items: presentUpazilas.map((upazila) {
                    return DropdownMenuItem(value: upazila, child: SizedBox(width: MediaQuery.of(context).size.width * 0.8, child: Text(upazila.localizedName(context))));
                  }).toList(),
                  onChanged: (val) => setState(() => _presentUpazila = val),
                ),
                Divider(),
                Text(AppLocalizations.of(context)!.permanentAddress, style: TextStyle(fontWeight: FontWeight.bold)),
                DropdownButtonFormField<Division>(
                  decoration: InputDecoration(label: buildRequiredLabel(AppLocalizations.of(context)!.division)),
                  value: _permanentDivision,
                  items: divisions.map((division) {
                    return DropdownMenuItem(value: division, child: SizedBox(width: MediaQuery.of(context).size.width * 0.8, child: Text(division.localizedName(context))));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _permanentDivision = value;
                      _permanentDistrict = null;
                      _permanentUpazila = null;
                    });
                    fetchPermanentDistricts(value!.id);
                  },
                ),
                DropdownButtonFormField<District>(
                  decoration: InputDecoration(label: buildRequiredLabel(AppLocalizations.of(context)!.district)),
                  value: _permanentDistrict,
                  items: permanentDistricts.map((district) {
                    return DropdownMenuItem(value: district, child: SizedBox(width: MediaQuery.of(context).size.width * 0.8, child: Text(district.localizedName(context))));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _permanentDistrict = value;
                      _permanentUpazila = null;
                    });
                    fetchPermanentUpazilas(value!.id);
                  },
                ),
                DropdownButtonFormField<Upazila>(
                  decoration: InputDecoration(label: buildRequiredLabel(AppLocalizations.of(context)!.upazila)),
                  value: _permanentUpazila,
                  items: permanentUpazilas.map((upazila) {
                    return DropdownMenuItem(value: upazila, child: SizedBox(width: MediaQuery.of(context).size.width * 0.8, child: Text(upazila.localizedName(context))));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _permanentUpazila = value;
                    });
        
                  },
                ),

                SizedBox(height: 20),
                ElevatedButton(
                  child: Text(AppLocalizations.of(context)!.next),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _submitDetails();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}