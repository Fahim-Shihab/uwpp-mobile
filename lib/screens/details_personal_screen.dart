import 'package:flutter/material.dart';
import 'package:ubp/models/religion.dart';
import 'package:ubp/screens/details_address_screen.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../utils/form_utils.dart';


class DetailsPersonalScreen extends StatefulWidget {
  final String nid;
  final String mobile;
  final String dob;
  final String token;
  final Map<String, dynamic> resJson;

  const DetailsPersonalScreen({super.key, required this.nid, required this.mobile, required this.dob, required this.token, required this.resJson });

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


  final mockResponseJson = {
    "limsResponse": {
      "status": 200,
      "message": "Your data has been received successfully.",
      "nid": null,
      "alternateNid": null,
      "dateOfBirth": "1985-11-15T00:00:00.000+0000",
      "nameEn": "ZAHIRUL ISLAM KHAN",
      "nameBn": "জহিরুল ইসলাম খান",
      "fatherNameEn": null,
      "fatherNameBn": "আব্দুল হালিম খান",
      "motherNameEn": null,
      "motherNameBn": "সাজেদা খানম",
      "gender": "Male",
      "mobile": "01712286734",
      "religion": null,
      "instituteTypeId": 9,
      "factoryId": 181861,
      "workerId": "S-4873",
      "dateOfJoining": "2023-02-15T00:00:00.000+0000",
      "presentAddress": {
        "divisionName": "Dhaka",
        "divisionCode": "30",
        "districtName": "Tangail",
        "districtCode": "93",
        "upazilaName": null,
        "upazilaCode": null
      },
      "permanentAddress": {
        "divisionName": "Dhaka",
        "divisionCode": "30",
        "districtName": "Tangail",
        "districtCode": "93",
        "upazilaName": null,
        "upazilaCode": null
      }
    }
  };

  @override
  void initState() {
    super.initState();
    token = widget.token;
    print(widget.resJson);
    //print(mockResponseJson);
    initializeData();
  }

  Future<void> initializeData() async {
    //TODO: send actual data
    final lims = widget.resJson['limsResponse'];
    //final lims = mockResponseJson['limsResponse'];
    _nameEnController.text = lims?['nameEn'] as String? ?? '';
    _fatherEnController.text = lims?['fatherNameEn'] as String? ?? '';
    _motherEnController.text = lims?['motherNameEn'] as String? ?? '';
    _nameBnController.text = lims?['nameBn'] as String? ?? '';
    _fatherBnController.text = lims?['fatherNameBn'] as String? ?? '';
    _motherBnController.text = lims?['motherNameBn'] as String? ?? '';
    _gender = lims?['gender'] as String?;
    isGenderPrefilled = _gender != null;

  }

  bool isFieldDisabled(TextEditingController controller) => controller.text.isNotEmpty;

  Future<void> _submitDetails() async {
    if (_gender == null || _nameEnController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.fillFields)));
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
      "gender": _gender=="Male"? "1" : "2",
      "id": null,
      "religion": _selectedReligion?.id,
    };

    userJson.removeWhere((key, value) => value == null || (value is String && value.trim().isEmpty));

    // ✅ Navigate to banking page with this JSON
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailsAddressScreen(
          token: token,
          userJson: userJson,
          resJson: widget.resJson,
          //resJson: mockResponseJson
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
        ],),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(controller: _nameEnController, enabled: !isFieldDisabled(_nameEnController), decoration: InputDecoration(label: buildRequiredLabel(AppLocalizations.of(context)!.nameEn))),
                TextFormField(controller: _nameBnController, enabled: !isFieldDisabled(_nameBnController), decoration: InputDecoration(labelText: AppLocalizations.of(context)!.nameBn)),
                TextFormField(controller: _fatherEnController, enabled: !isFieldDisabled(_fatherEnController), decoration: InputDecoration(labelText: AppLocalizations.of(context)!.fatherNameEn)),
                TextFormField(controller: _fatherBnController, enabled: !isFieldDisabled(_fatherBnController), decoration: InputDecoration(labelText: AppLocalizations.of(context)!.fatherNameBn)),
                TextFormField(controller: _motherEnController, enabled: !isFieldDisabled(_motherEnController), decoration: InputDecoration(labelText: AppLocalizations.of(context)!.motherNameEn)),
                TextFormField(controller: _motherBnController, enabled: !isFieldDisabled(_motherBnController), decoration: InputDecoration(labelText: AppLocalizations.of(context)!.motherNameBn)),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(label: buildRequiredLabel(AppLocalizations.of(context)!.gender)),
                  value: _gender,
                  items: _buildGenderItems(context),
                  onChanged: isGenderPrefilled
                      ? null // disable if gender came from JSON
                      : (val) => setState(() => _gender = val),
                ),
                DropdownButtonFormField<Religion>(
                  decoration: InputDecoration(labelText: AppLocalizations.of(context)!.religion),
                  value: _selectedReligion,
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