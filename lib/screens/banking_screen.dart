import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:ubp/screens/upload_screen.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../models/bank.dart';
import '../models/bankBranch.dart';
import '../models/mfs.dart';
import '../utils/constants.dart';
import '../utils/form_utils.dart';

class BankingPage extends StatefulWidget {
  final String token;
  final Map<String, dynamic> userJson;

  const BankingPage({super.key, required this.token, required this.userJson});

  @override
  State<BankingPage> createState() => _BankingPageState();
}



class _BankingPageState extends State<BankingPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  List<Bank> banks = [];
  List<BankBranch> branches = [];
  List<MFS> mfsList = [];

  String? paymentMode;
  Bank? selectedBank;
  BankBranch? selectedBranch;
  MFS? selectedMfs;
  int? routingNumber;

  bool isMfsVerified = false;
  bool mfsVerificationRequired = false;

  Future<void> _submitBankingDetails() async {
    if (paymentMode == null || routingNumber == null || _accountNameController.text.isEmpty || _accountNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.fillFields)));
      return;
    }
    if(paymentMode == "Bank"){
      if(selectedBank == null || selectedBranch == null){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.fillFields)));
        return;
      }
    }
    else if (paymentMode == "MFS"){
      if(selectedMfs == null){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.fillFields)));
        return;
      }
    }
    final uri = Uri.parse('$actualBaseUrl/applicant/self-registration/save');

    if (paymentMode == "Bank" && selectedBank != null) {
      widget.userJson['bank'] = selectedBank!.id;
      widget.userJson['branch'] = selectedBranch!.id;
    } else if (paymentMode == "MFS" && selectedMfs != null) {
      widget.userJson['bank'] = selectedMfs!.id;
    }
    widget.userJson['routingNumber'] = routingNumber;
    widget.userJson['accountName'] = _accountNameController.text;
    widget.userJson['paymentService'] = paymentMode=="Bank"? "1" : "2";
    widget.userJson['accountNumber'] = _accountNumberController.text;

    print(widget.userJson);

    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.token}",
      },
      body: jsonEncode(widget.userJson),
    );

    if (!mounted) return;
    if (response.statusCode == 200) {
      // print(jsonDecode(response.body)["status"]);
      print(jsonDecode(response.body)["errors"]);
      // print("The full json response is:");
      // print(jsonDecode(response.body));
      final errors = jsonDecode(response.body)["errors"];
      final errorMessage = errors is List
          ? errors.join('\n') // join list items with new lines
          : errors.toString(); // fallback if not a list

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => UploadScreen(
            nid: widget.userJson["nid"],
            mobile: widget.userJson["mobileNumber"],
            dob: widget.userJson["dob"],
            token: widget.token,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.failBankSubmit)),
      );
    }
  }

  Future<void> verifyMFS() async {
    if(_accountNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.accNumErr)),
      );
      return;
    }
    final uri = Uri.parse('$actualBaseUrl/applicant/verify-mfs');

    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.token}",
      },
      body: json.encode({
        "nid": widget.userJson['nid'],
        "mfsId": selectedMfs?.id,
        "mobileNo": widget.userJson['mobileNumber']
      })
    );

    print(json.encode({
      "nid": widget.userJson['nid'],
      "mfsId": selectedMfs?.id,
      "mobileNo": widget.userJson['mobileNumber']
    }));
    if (!mounted) return;
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("the mfs verify data is");
      print(data);
      final ibasResponse = data['ibasMfsResponse'];
      if (ibasResponse['AccountExist'] == true && ibasResponse['NIDMatched'] == true) {
        setState(() {
          isMfsVerified = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.mfsVerifiedSuccess)),
        );
      } else {
        setState(() {
          isMfsVerified = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.mfsVerifiedFail)),
        );
      }
    } else {
      setState(() {
        isMfsVerified = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.mfsVerifiedFail)),
      );
    }

  }

  Future<List<Bank>> fetchBanks() async {
    final res = await http.get(Uri.parse('$actualBaseUrl/lookup/bank/get'),
      headers: {
        'Accept': 'application/json',
        "Authorization": "Bearer ${widget.token}",
      },);
    if (res.statusCode == 200) {
      List jsonList = json.decode(res.body);
      return jsonList.map((e) => Bank.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load banks');
    }
  }

  Future<List<BankBranch>> fetchBranches(int bankId) async {
    final res = await http.get(Uri.parse('$actualBaseUrl/lookup/bank-branch/get?bankId=$bankId'),
      headers: {
        'Accept': 'application/json',
        "Authorization": "Bearer ${widget.token}",
      },);
    if (res.statusCode == 200) {
      List jsonList = json.decode(res.body);
      return jsonList.map((e) => BankBranch.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load branches');
    }
  }

  Future<List<MFS>> fetchMFS() async {
    final res = await http.get(Uri.parse('$actualBaseUrl/lookup/mfs/get'),
      headers: {
        'Accept': 'application/json',
        "Authorization": "Bearer ${widget.token}",
      },);
    if (res.statusCode == 200) {
      List jsonList = json.decode(res.body);
      return jsonList.map((e) => MFS.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load MFS providers');
    }
  }

  Map<String, String> getLocalizedPaymentModes(BuildContext context) {
    final isBn = Localizations.localeOf(context).languageCode == 'bn';
    return {
      'Bank': isBn ? 'ব্যাংক' : 'Bank',
      'MFS': isBn ? 'মোবাইল ফাইন্যান্স' : 'MFS',
    };
  }


  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.bankingInfo),
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(label: buildRequiredLabel(AppLocalizations.of(context)!.paymentMode)),
                    value: paymentMode,
                    items: getLocalizedPaymentModes(context).entries
                        .map((entry) => DropdownMenuItem(
                      value: entry.key, // value stays as 'Bank' or 'MFS'
                      child: Text(entry.value), // label shown to user
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        paymentMode = value;
                        selectedBank = null;
                        selectedBranch = null;
                        selectedMfs = null;
                        routingNumber = null;

                        if (value == 'Bank') {
                          fetchBanks().then((list) => setState(() => banks = list));
                        } else if (value == 'MFS') {
                          fetchMFS().then((list) => setState(() => mfsList = list));
                        }
                      });
                    },
                  ),

                  if (paymentMode == 'Bank') ...[
                    DropdownButtonFormField<Bank>(
                      decoration: InputDecoration(label: buildRequiredLabel(AppLocalizations.of(context)!.bank)),
                      value: selectedBank,
                      items: banks
                          .map((bank) => DropdownMenuItem(value: bank, child: SizedBox(width: MediaQuery.of(context).size.width * 0.8, child: Text(bank.localizedName(context)))))
                          .toList(),
                      onChanged: (bank) {
                        setState(() {
                          selectedBank = bank;
                          selectedBranch = null;
                        });
                        fetchBranches(bank!.id).then((list) => setState(() => branches = list));
                      },
                    ),

                    DropdownButtonFormField<BankBranch>(
                      decoration: InputDecoration(label: buildRequiredLabel(AppLocalizations.of(context)!.branch)),
                      value: selectedBranch,
                      items: branches
                          .map((branch) => DropdownMenuItem(value: branch, child: SizedBox(width: MediaQuery.of(context).size.width * 0.8, child: Text(branch.localizedName(context)))))
                          .toList(),
                      onChanged: (branch) {
                        setState(() {
                          selectedBranch = branch;
                          routingNumber = branch!.routingNumber;
                        });
                      },
                    ),
                  ],

                  if (paymentMode == 'MFS') ...[
                    DropdownButtonFormField<MFS>(
                      decoration: InputDecoration(label: buildRequiredLabel(AppLocalizations.of(context)!.mfsProv)),
                      value: selectedMfs,
                      items: mfsList
                          .map((mfs) => DropdownMenuItem(value: mfs, child: SizedBox(width: MediaQuery.of(context).size.width * 0.8, child: Text(mfs.localizedName(context)))))
                          .toList(),
                      onChanged: (mfs) {
                        setState(() {
                          selectedMfs = mfs;
                          routingNumber = mfs?.routingNumber;
                          isMfsVerified = false; // Reset verification
                          mfsVerificationRequired = [1, 2, 4, 7].contains(mfs?.id);
                        });
                      },
                    ),
                  ],

                  TextFormField(
                    controller: _accountNameController,
                    decoration: InputDecoration(label: buildRequiredLabel(AppLocalizations.of(context)!.accName)),
                  ),
                  TextFormField(
                    controller: _accountNumberController,
                    decoration: InputDecoration(label: buildRequiredLabel(AppLocalizations.of(context)!.accNum)),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly, // only allow numbers
                      LengthLimitingTextInputFormatter(17),   // max 12 digits
                    ],
                    validator: (value) {
                      if (value!.length < 11 || value.length > 17) {
                        return AppLocalizations.of(context)!.accNumErr;
                      }
                      return null; // ✅ valid input
                    },
                  ),

                  const SizedBox(height: 16),

                  if (paymentMode == 'MFS' && [1, 2, 4, 7].contains(selectedMfs?.id)) ...[
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        verifyMFS();
                      },
                      child: Text(AppLocalizations.of(context)!.verify),
                    )
                  ],

                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: () {
                      final mfsNeedsVerification = paymentMode == 'MFS' && mfsVerificationRequired;
                      if (_formKey.currentState!.validate()) {
                        if (mfsNeedsVerification && !isMfsVerified) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(AppLocalizations.of(context)!.pleaseVerifyMfs)),
                          );
                          return;
                        }
                        _submitBankingDetails();
                      }
                    },
                    child: Text(AppLocalizations.of(context)!.submit),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
