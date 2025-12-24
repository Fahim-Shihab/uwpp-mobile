import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ubp/models/religion.dart';
import 'package:ubp/screens/details_address_screen.dart';

import '../l10n/app_localizations.dart';
import '../main.dart';
import '../models/district.dart';
import '../utils/constants.dart';
import '../utils/form_utils.dart';

class DetailsPersonalScreen extends StatefulWidget {
  final String nid;
  final String mobile;
  final String dob;
  final String token;
  final String nameEn;
  final Map<String, dynamic> resJson;

  const DetailsPersonalScreen({
    super.key,
    required this.nid,
    required this.mobile,
    required this.dob,
    required this.token,
    required this.nameEn,
    required this.resJson,
  });

  @override
  DetailsPersonalScreenState createState() => DetailsPersonalScreenState();
}

class DetailsPersonalScreenState extends State<DetailsPersonalScreen> {
  final _formKey = GlobalKey<FormState>();
  String token = "";

  // Controllers
  final _nameEnController = TextEditingController();
  final _nameBnController = TextEditingController();
  final _fatherEnController = TextEditingController();
  final _fatherBnController = TextEditingController();
  final _motherEnController = TextEditingController();
  final _motherBnController = TextEditingController();
  String? _gender;
  Religion? _selectedReligion;
  bool isGenderPrefilled = false;
  District? _birthPlaceDistrict;
  List<District> birthPlaceDistricts = [];

  @override
  void initState() {
    super.initState();
    token = widget.token;
    print(widget.resJson);
    initializeData();
  }

  Future<void> initializeData() async {
    await fetchDistricts();
    final lims = widget.resJson['limsResponse'];
    _nameEnController.text = widget.nameEn;
    _fatherEnController.text = lims?['fatherNameEn'] as String? ?? '';
    _motherEnController.text = lims?['motherNameEn'] as String? ?? '';
    _nameBnController.text = lims?['nameBn'] as String? ?? '';
    _fatherBnController.text = lims?['fatherNameBn'] as String? ?? '';
    _motherBnController.text = lims?['motherNameBn'] as String? ?? '';
    _gender = lims?['gender'] as String?;
    isGenderPrefilled = _gender != null;
  }

  Future<void> fetchDistricts() async {
    final url = Uri.parse("$actualBaseUrl/api/geo/district/byDivision");
    final body = json.encode({"id": null});
    final String token = widget.token;

    print("url: " + url.toString());

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        birthPlaceDistricts = data
            .map((json) => District.fromJson(json))
            .toList();
        _birthPlaceDistrict = null;
      });
    }
  }

  bool isFieldDisabled(TextEditingController controller) =>
      controller.text.isNotEmpty;

  String? _validateInput(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.validInput;
    }
    return null;
  }

  String? _validateReligion(Religion? value) {
    if (value == null) {
      return AppLocalizations.of(context)!.validInput;
    }
    return null;
  }

  String? _validateBirthPlace(District? value) {
    if (value == null) {
      return AppLocalizations.of(context)!.validInput;
    }
    return null;
  }

  Future<void> _submitDetails() async {
    if (_gender == null || _nameEnController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.fillFields)),
      );
      return;
    }

    final userJson = {
      "nid": widget.nid,
      "mobileNumber": widget.mobile,
      "nameEn": _nameEnController.text,
      "nameBn": _nameBnController.text,
      "dob": widget.dob,
      "fatherNameEn": _fatherEnController.text,
      "motherNameEn": _motherEnController.text,
      "fatherNameBn": _fatherBnController.text,
      "motherNameBn": _motherBnController.text,
      "gender": _gender == "Male"
          ? "1"
          : _gender == "Female"
          ? "2"
          : "3",
      "id": null,
      "religion": _selectedReligion?.id,
      "birthPlaceDistrict": _birthPlaceDistrict?.id,
    };

    userJson.removeWhere(
      (key, value) =>
          value == null || (value is String && value.trim().isEmpty),
    );

    // ✅ Navigate to banking page with this JSON
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailsAddressScreen(
          token: token,
          userJson: userJson,
          resJson: widget.resJson,
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _buildGenderItems(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;

    return [
      DropdownMenuItem(
        value: 'Male',
        child: Text(locale == 'bn' ? 'পুরুষ' : 'Male'),
      ),
      DropdownMenuItem(
        value: 'Female',
        child: Text(locale == 'bn' ? 'মহিলা' : 'Female'),
      ),
      DropdownMenuItem(
        value: 'Other',
        child: Text(locale == 'bn' ? 'অন্যান্য' : 'Other'),
      ),
    ];
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 20),
                TextFormField(
                  controller: _nameEnController,
                  enabled: !isFieldDisabled(_nameEnController),
                  decoration: InputDecoration(
                    label: buildRequiredLabel(
                      AppLocalizations.of(context)!.nameEn,
                    ),
                  ),
                  validator: _validateInput,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _nameBnController,
                  enabled: !isFieldDisabled(_nameBnController),
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.nameBn,
                  ),
                  validator: _validateInput,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _fatherEnController,
                  enabled: !isFieldDisabled(_fatherEnController),
                  decoration: InputDecoration(
                    label: buildRequiredLabel(
                      AppLocalizations.of(context)!.fatherNameEn,
                    ),
                  ),
                  validator: _validateInput,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _fatherBnController,
                  enabled: !isFieldDisabled(_fatherBnController),
                  decoration: InputDecoration(
                    label: buildRequiredLabel(
                      AppLocalizations.of(context)!.fatherNameBn,
                    ),
                  ),
                  validator: _validateInput,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _motherEnController,
                  enabled: !isFieldDisabled(_motherEnController),
                  decoration: InputDecoration(
                    label: buildRequiredLabel(
                      AppLocalizations.of(context)!.motherNameEn,
                    ),
                  ),
                  validator: _validateInput,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _motherBnController,
                  enabled: !isFieldDisabled(_motherBnController),
                  decoration: InputDecoration(
                    label: buildRequiredLabel(
                      AppLocalizations.of(context)!.motherNameBn,
                    ),
                  ),
                  validator: _validateInput,
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    label: buildRequiredLabel(
                      AppLocalizations.of(context)!.gender,
                    ),
                  ),
                  initialValue: _gender,
                  items: _buildGenderItems(context),
                  onChanged: isGenderPrefilled
                      ? null // disable if gender came from JSON
                      : (val) => setState(() => _gender = val),
                  validator: _validateInput,
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<Religion>(
                  decoration: InputDecoration(
                    label: buildRequiredLabel(
                      AppLocalizations.of(context)!.religion,
                    ),
                  ),
                  initialValue: _selectedReligion,
                  items: religions.map((Religion religion) {
                    return DropdownMenuItem<Religion>(
                      value: religion,
                      child: Text(religion.localizedName(context)),
                    );
                  }).toList(),
                  onChanged: (Religion? newValue) {
                    setState(() {
                      _selectedReligion = newValue;
                    });
                  },
                  validator: _validateReligion,
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<District>(
                  decoration: InputDecoration(
                    label: buildRequiredLabel(
                      AppLocalizations.of(context)!.district,
                    ),
                  ),
                  initialValue: _birthPlaceDistrict,
                  items: birthPlaceDistricts.map((district) {
                    return DropdownMenuItem(
                      value: district,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(district.localizedName(context)),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _birthPlaceDistrict = value;
                    });
                  },
                  validator: _validateBirthPlace,
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
