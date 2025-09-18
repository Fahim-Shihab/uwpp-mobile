import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../utils/form_utils.dart';
import 'banking_screen.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constants.dart';
import '../models/association.dart';
import '../models/factory.dart';
import '../models/unemploymentReason.dart';
import '../models/designation.dart';

class DetailsWorkScreen extends StatefulWidget {
  final String token;
  final Map<String, dynamic> resJson;
  final Map<String, dynamic> userJson;

  const DetailsWorkScreen({super.key, required this.token, required this.resJson, required this.userJson });

  @override
  DetailsWorkScreenState createState() => DetailsWorkScreenState();
}

class DetailsWorkScreenState extends State<DetailsWorkScreen> {
  final _formKey = GlobalKey<FormState>();
  String token = "";
  // Controllers
  final _workerIdController = TextEditingController();
  Association? _association;
  Factory? _factory;
  Designation? _designation;
  DateTime? _employmentDate;
  DateTime? _unemploymentDate;
  UnemploymentReason? _unemploymentReason;

  List<Association> associations = [];
  List<Factory> factories = [];
  List<Designation> designations = [];
  List<UnemploymentReason> unemploymentReasons = [];

  bool isAssociationPrefilled = false;
  bool isFactoryPrefilled = false;
  bool isEmploymentDatePrefilled = false;

  @override
  void initState() {
    super.initState();
    token = widget.token;
    print(widget.resJson);
    //print(mockResponseJson);
    initializeData();
  }

  Future<void> initializeData() async {
    await fetchAssociations(); // <-- Fetch factories on load
    await fetchUnemploymentReasons();
    await fetchDesignations();

    final lims = widget.resJson['limsResponse'];
    _workerIdController.text = lims?['workerId'] as String? ?? '';

    final String? dateOfJoiningStr = lims?['dateOfJoining'] as String?;
    if (dateOfJoiningStr != null) {
      final parsedDate = DateTime.tryParse(dateOfJoiningStr);
      if (parsedDate != null) {
        _employmentDate = parsedDate;
        isEmploymentDatePrefilled = true;
      }
    }

    final int? factoryId = lims?['factoryId'] as int?;
    final int? associationId = lims?['instituteTypeId'] as int?;
    if (associationId != null) {
      final matched = associations.where((f) => f.id == associationId);
      if (matched.isNotEmpty) {
        _association = matched.first;
        isAssociationPrefilled = true;
        await fetchFactories(_association!.id);
      }
    }
    if (factoryId != null && associationId != null) {
      final matchedFactory = factories.where((f) => f.id == factoryId);
      if (matchedFactory.isNotEmpty) {
        setState(() {
          _factory = matchedFactory.first;
          isFactoryPrefilled = true; // <-- ✅ Mark as prefilled
        });
      }
    }

    setState(() {});
  }

  bool isFieldDisabled(TextEditingController controller) => controller.text.isNotEmpty;

  Future<void> fetchAssociations() async {
    final response = await http.get(
        Uri.parse('$actualBaseUrl/lookup/association/active'),
        headers: {
          'Accept': 'application/json',
          "Authorization": "Bearer $token",
        },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        associations = data.map((json) => Association.fromJson(json)).toList();
        _association = null;
      });
    } else {
      // Handle error
    }
  }

  Future<void> fetchFactories(int id) async {
    final response = await http.get(
      Uri.parse('$actualBaseUrl/lookup/factory/active?associationId=$id'),
      headers: {
        'Accept': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        factories = data.map((json) => Factory.fromJson(json)).toList();
        _factory = null;
      });
    } else {
      // Handle error
    }
  }

  Future<void> fetchUnemploymentReasons() async {
    final response = await http.get(Uri.parse('$actualBaseUrl/lookup/selection-reason/get'),
      headers: {
        'Accept': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        unemploymentReasons = data.map((json) => UnemploymentReason.fromJson(json)).toList();
        _unemploymentReason = null;
      });
    }
  }

  Future<void> fetchDesignations() async {
    final response = await http.get(Uri.parse('$actualBaseUrl/lookup/occupation/get'),
      headers: {
        'Accept': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        designations = data.map((json) => Designation.fromJson(json)).toList();
        _designation = null;
      });
    }
  }


  Future<void> _pickDate(BuildContext context, bool isEmployment) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isEmployment) {
          _employmentDate = picked;
          isEmploymentDatePrefilled = false; // <-- Allow re-edit
        } else {
          _unemploymentDate = picked;
        }
      });
    }
  }

  String? _formatDate(DateTime? date) {
    if (date == null) return null;
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> _submitDetails() async {
    if (_association == null || _factory == null || _employmentDate == null || _unemploymentDate == null || _unemploymentReason == null || _workerIdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.fillFields)));
      return;
    }
     //"association": _association!.id,
    widget.userJson["institutionId"] = _factory!.id;
    if (_designation != null) {
      widget.userJson["occupation"] = _designation!.id;
    }
    widget.userJson["dateOfEmployment"] = _formatDate(_employmentDate);
    widget.userJson["dateOfUnEmployment"] = _formatDate(_unemploymentDate);
    widget.userJson["reason"] = {
        "id": _unemploymentReason!.id,
      };
    widget.userJson["workerId"] = _workerIdController.text;
    print("Final userJson");
    print(widget.userJson);

    // ✅ Navigate to banking page with this JSON
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BankingPage(
          token: token,
          userJson: widget.userJson,
        ),
      ),
    );
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
                DropdownButtonFormField<Association>(
                  decoration: InputDecoration(label: buildRequiredLabel(AppLocalizations.of(context)!.association)),
                  value: _association,
                  items: associations.map((association) {
                    return DropdownMenuItem(value: association, child: SizedBox(width: MediaQuery.of(context).size.width * 0.8, child: Text(association.localizedName(context))));
                  }).toList(),
                  onChanged: isAssociationPrefilled
                      ? null // disables the dropdown
                      : (value) {
                    setState(() {
                      _association = value;
                      _factory = null;
                    });
                    fetchFactories(value!.id);
                  },
                ),
                DropdownButtonFormField<Factory>(
                  decoration: InputDecoration(label: buildRequiredLabel(AppLocalizations.of(context)!.factory)),
                  value: _factory,
                  items: factories.map((factory) {
                    return DropdownMenuItem(value: factory, child: SizedBox(width: MediaQuery.of(context).size.width * 0.8, child: Text(factory.localizedName(context))));
                  }).toList(),
                  onChanged: isFactoryPrefilled
                      ? null // ✅ Disable only if prefilled from JSON
                      : (value) {
                    setState(() {
                      _factory = value;
                    });
                  },
                ),
                DropdownButtonFormField<Designation>(
                  decoration: InputDecoration(labelText: AppLocalizations.of(context)!.designation),
                  value: _designation,
                  items: designations.map((designation) {
                    return DropdownMenuItem(value: designation, child: SizedBox(width: MediaQuery.of(context).size.width * 0.8, child: Text(designation.localizedName(context))));
                  }).toList(),
                  onChanged: (val) => setState(() => _designation = val),
                ),
                TextFormField(
                  controller: _workerIdController,
                  keyboardType: TextInputType.number,
                  enabled: !isFieldDisabled(_workerIdController),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly, // only allow numbers
                    LengthLimitingTextInputFormatter(12),   // max 12 digits
                  ],
                  decoration: InputDecoration(label: buildRequiredLabel(AppLocalizations.of(context)!.linNum)),
                  //TODO: validate LIN Number
                  // validator: (value) {
                  //   if (value!.length != 12) {
                  //     return AppLocalizations.of(context)!.linErr;
                  //   }
                  //   return null; // ✅ valid input
                  // },
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: buildRequiredTextLabel(AppLocalizations.of(context)!.dateEmp),
                ),

                ElevatedButton(
                  onPressed: isEmploymentDatePrefilled
                      ? null // disable if prefilled
                      : () => _pickDate(context, true),
                  child: Text(
                    _employmentDate == null
                        ? AppLocalizations.of(context)!.pickDate
                        : _formatDate(_employmentDate)!,
                  ),
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: buildRequiredTextLabel(AppLocalizations.of(context)!.dateUnemp),
                ),
                ElevatedButton(
                  child: Text(
                    _unemploymentDate == null
                        ? AppLocalizations.of(context)!.pickDate
                        : _formatDate(_unemploymentDate)!,
                  ),
                  onPressed: () => _pickDate(context, false),
                ),
                DropdownButtonFormField<UnemploymentReason>(
                  decoration: InputDecoration(label: buildRequiredLabel(AppLocalizations.of(context)!.unempReason)),
                  value: _unemploymentReason,
                  items: unemploymentReasons.map((reason) {
                    return DropdownMenuItem(value: reason, child: SizedBox(width: MediaQuery.of(context).size.width * 0.8, child: Text(reason.localizedName(context))));
                  }).toList(),
                  onChanged: (val) => setState(() => _unemploymentReason = val),
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