import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:ubp/screens/landing_screen.dart';
import 'package:ubp/screens/waiting_screen.dart';

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
  final TextEditingController _accountNumberController =
      TextEditingController();
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

  File? employmentImage;
  File? unemploymentImage;
  File? facePhotoImage;
  File? nidCardImage;

  bool isUploadingEmployment = false;
  bool isUploadingUnemployment = false;
  bool isUploadingFacePhoto = false;
  bool isUploadingNidCard = false;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _accountNameController.text = widget.userJson['nameEn'];
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(int fileTypeId) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    ); // Or use ImageSource.camera

    if (pickedFile != null) {
      setState(() {
        if (fileTypeId == 1) {
          employmentImage = File(pickedFile.path);
        } else if (fileTypeId == 2) {
          unemploymentImage = File(pickedFile.path);
        } else if (fileTypeId == 3) {
          facePhotoImage = File(pickedFile.path);
        } else if (fileTypeId == 4) {
          nidCardImage = File(pickedFile.path);
        }
      });
    }
  }

  Future<void> submitFiles() async {
    setState(() {
      isSubmitting = true;
    });

    final uri = Uri.parse(
      "$actualBaseUrl/applicant/self-registration/upload-attachment",
    );

    final token = widget.token;

    final files = <http.MultipartFile>[];

    if (employmentImage != null) {
      files.add(
        await http.MultipartFile.fromPath(
          'employment',
          employmentImage!.path,
          filename: p.basename(employmentImage!.path),
          contentType: _getContentType(employmentImage!.path),
        ),
      );
    }

    if (unemploymentImage != null) {
      files.add(
        await http.MultipartFile.fromPath(
          'unemployment',
          unemploymentImage!.path,
          filename: p.basename(unemploymentImage!.path),
          contentType: _getContentType(unemploymentImage!.path),
        ),
      );
    }

    if (facePhotoImage != null) {
      files.add(
        await http.MultipartFile.fromPath(
          'facePhoto',
          facePhotoImage!.path,
          filename: p.basename(facePhotoImage!.path),
          contentType: _getContentType(facePhotoImage!.path),
        ),
      );
    }

    if (nidCardImage != null) {
      files.add(
        await http.MultipartFile.fromPath(
          'nidCard',
          nidCardImage!.path,
          filename: p.basename(nidCardImage!.path),
          contentType: _getContentType(nidCardImage!.path),
        ),
      );
    }

    Navigator.push(context, MaterialPageRoute(builder: (_) => WaitingScreen()));

    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['nid'] = widget.userJson["nid"]
      ..files.addAll(files);

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    setState(() {
      isSubmitting = false;
    });

    Navigator.pop(context);

    if (!mounted) return;
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.uploadSuccess),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        final errors = jsonDecode(response.body)["message"];
        final errorMessage = errors is List
            ? errors.join('\n')
            : errors.toString();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.uploadFail)),
      );
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => LandingScreen(
          mobile: widget.userJson["mobileNumber"],
          token: widget.token,
        ),
      ),
      (route) => false,
    );
  }

  // Helper to set correct content type based on file extension
  MediaType _getContentType(String filePath) {
    final ext = p.extension(filePath).toLowerCase();
    switch (ext) {
      case '.jpg':
      case '.jpeg':
        return MediaType('image', 'jpeg');
      case '.png':
        return MediaType('image', 'png');
      case '.gif':
        return MediaType('image', 'gif');
      default:
        return MediaType('application', 'octet-stream');
    }
  }

  Widget buildImageUploadSection({
    required String label,
    required int fileTypeId,
    required File? file,
    required bool isUploading,
  }) {
    if (fileTypeId == 1) {
      label += ' *';
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  if (fileTypeId == 1) {
                    isUploadingEmployment = true;
                  } else if (fileTypeId == 2) {
                    isUploadingUnemployment = true;
                  } else if (fileTypeId == 3) {
                    isUploadingFacePhoto = true;
                  } else if (fileTypeId == 4) {
                    isUploadingNidCard = true;
                  }
                });

                await pickImage(fileTypeId);

                setState(() {
                  if (fileTypeId == 1) {
                    isUploadingEmployment = false;
                  } else if (fileTypeId == 2) {
                    isUploadingUnemployment = false;
                  } else if (fileTypeId == 3) {
                    isUploadingFacePhoto = false;
                  } else if (fileTypeId == 4) {
                    isUploadingNidCard = false;
                  }
                });
              },
              child: Text(AppLocalizations.of(context)!.uploadImage),
            ),
            const SizedBox(width: 12),
            if (isUploading)
              SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else if (file != null)
              Expanded(
                child: Text(
                  p.basename(file.path),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  Future<void> _submitBankingDetails() async {
    if (paymentMode == null ||
        routingNumber == null ||
        _accountNameController.text.isEmpty ||
        _accountNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.fillFields)),
      );
      return;
    }
    if (paymentMode == "Bank") {
      if (selectedBank == null || selectedBranch == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.fillFields)),
        );
        return;
      }
      if (_accountNumberController.text.isEmpty ||
          _accountNumberController.text.length < 13) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.bankAccNumErr)),
        );
        return;
      }
    } else if (paymentMode == "MFS") {
      if (selectedMfs == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.fillFields)),
        );
        return;
      }
      if (_accountNumberController.text.isEmpty ||
          (_accountNumberController.text.length > 12 ||
              _accountNumberController.text.length < 11)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.accNumErr)),
        );
        return;
      }
    }

    if (employmentImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${AppLocalizations.of(context)!.certEmp} ${AppLocalizations.of(context)!.validInput}',
          ),
        ),
      );
      return;
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
    widget.userJson['paymentService'] = paymentMode == "Bank" ? "1" : "2";
    widget.userJson['accountNumber'] = _accountNumberController.text;

    print(widget.userJson);

    Navigator.push(context, MaterialPageRoute(builder: (_) => WaitingScreen()));

    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.token}",
      },
      body: jsonEncode(widget.userJson),
    );

    Navigator.pop(context);

    if (!mounted) return;
    if (response.statusCode == 200) {
      print(jsonDecode(response.body)["errors"]);
      if (jsonDecode(response.body)["status"] == 0) {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (_) => UploadScreen(
        //       nid: widget.userJson["nid"],
        //       mobile: widget.userJson["mobileNumber"],
        //       dob: widget.userJson["dob"],
        //       token: widget.token,
        //     ),
        //   ),
        // );

        submitFiles();
      } else {
        final errors = jsonDecode(response.body)["errors"];
        final errorMessage = errors is List
            ? errors.join('\n')
            : errors.toString();

        if (errors != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.failBankSubmit)),
      );
    }
  }

  Future<void> verifyMFS() async {
    if (_accountNumberController.text.isEmpty ||
        (_accountNumberController.text.length != 11 &&
            _accountNumberController.text.length != 12)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.accNumErr)),
      );
      return;
    }
    if (!_accountNumberController.text.startsWith("01")) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.accNumErr)),
      );
      return;
    }
    final uri = Uri.parse('$actualBaseUrl/applicant/verify-mfs');

    Navigator.push(context, MaterialPageRoute(builder: (_) => WaitingScreen()));

    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.token}",
      },
      body: json.encode({
        "nid": widget.userJson['nid'],
        "mfsId": selectedMfs?.id,
        "mobileNo": _accountNumberController.text,
      }),
    );

    Navigator.pop(context);

    if (!mounted) return;
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("the mfs verify data is");
      print(data);
      final ibasResponse = data['ibasMfsResponse'];
      if (ibasResponse['AccountExist'] == true &&
          ibasResponse['NIDMatched'] == true &&
          ibasResponse['NIDMobileMatched'] == true) {
        setState(() {
          isMfsVerified = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.mfsVerifiedSuccess),
          ),
        );
      } else {
        setState(() {
          isMfsVerified = false;
        });
        String msg = '';
        if (ibasResponse['AccountExist'] == false) {
          msg = AppLocalizations.of(context)!.accountNonExistent;
        } else if (ibasResponse['NIDMatched'] == false) {
          msg = AppLocalizations.of(context)!.accountNidNotMatchedWithGivenNid;
        } else if (ibasResponse['NIDMobileMatched'] == false) {
          msg = AppLocalizations.of(context)!.simNidNotMatchedWithGivenNid;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), duration: Duration(seconds: 2)),
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
    final res = await http.get(
      Uri.parse('$actualBaseUrl/lookup/bank/get'),
      headers: {
        'Accept': 'application/json',
        "Authorization": "Bearer ${widget.token}",
      },
    );
    if (res.statusCode == 200) {
      List jsonList = json.decode(res.body);
      return jsonList.map((e) => Bank.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load banks');
    }
  }

  Future<List<BankBranch>> fetchBranches(int bankId) async {
    final res = await http.get(
      Uri.parse('$actualBaseUrl/lookup/bank-branch/get?bankId=$bankId'),
      headers: {
        'Accept': 'application/json',
        "Authorization": "Bearer ${widget.token}",
      },
    );
    if (res.statusCode == 200) {
      List jsonList = json.decode(res.body);
      return jsonList.map((e) => BankBranch.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load branches');
    }
  }

  Future<List<MFS>> fetchMFS() async {
    final res = await http.get(
      Uri.parse('$actualBaseUrl/lookup/mfs/get'),
      headers: {
        'Accept': 'application/json',
        "Authorization": "Bearer ${widget.token}",
      },
    );
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
      'MFS': isBn ? 'মোবাইল ব্যাংকিং' : 'MFS',
    };
  }

  @override
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      label: buildRequiredLabel(
                        AppLocalizations.of(context)!.paymentMode,
                      ),
                    ),
                    initialValue: paymentMode,
                    items: getLocalizedPaymentModes(context).entries
                        .map(
                          (entry) => DropdownMenuItem(
                            value: entry.key, // value stays as 'Bank' or 'MFS'
                            child: Text(entry.value), // label shown to user
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        paymentMode = value;
                        selectedBank = null;
                        selectedBranch = null;
                        selectedMfs = null;
                        routingNumber = null;

                        if (value == 'Bank') {
                          fetchBanks().then(
                            (list) => setState(() => banks = list),
                          );
                        } else if (value == 'MFS') {
                          fetchMFS().then(
                            (list) => setState(() => mfsList = list),
                          );
                        }
                      });
                    },
                  ),
                  SizedBox(height: 5),
                  if (paymentMode == 'Bank') ...[
                    DropdownButtonFormField<Bank>(
                      decoration: InputDecoration(
                        label: buildRequiredLabel(
                          AppLocalizations.of(context)!.bank,
                        ),
                      ),
                      initialValue: selectedBank,
                      items: banks
                          .map(
                            (bank) => DropdownMenuItem(
                              value: bank,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Text(bank.localizedName(context)),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (bank) {
                        setState(() {
                          selectedBank = bank;
                          selectedBranch = null;
                        });
                        fetchBranches(
                          bank!.id,
                        ).then((list) => setState(() => branches = list));
                      },
                    ),

                    DropdownButtonFormField<BankBranch>(
                      decoration: InputDecoration(
                        label: buildRequiredLabel(
                          AppLocalizations.of(context)!.branch,
                        ),
                      ),
                      initialValue: selectedBranch,
                      items: branches
                          .map(
                            (branch) => DropdownMenuItem(
                              value: branch,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Text(branch.localizedName(context)),
                              ),
                            ),
                          )
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
                      decoration: InputDecoration(
                        label: buildRequiredLabel(
                          AppLocalizations.of(context)!.mfsProv,
                        ),
                      ),
                      initialValue: selectedMfs,
                      items: mfsList
                          .map(
                            (mfs) => DropdownMenuItem(
                              value: mfs,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Text(mfs.localizedName(context)),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (mfs) {
                        setState(() {
                          selectedMfs = mfs;
                          routingNumber = mfs?.routingNumber;
                          isMfsVerified = false; // Reset verification
                          mfsVerificationRequired = [
                            1,
                            2,
                            4,
                            7,
                          ].contains(mfs?.id);
                        });
                      },
                    ),
                  ],

                  SizedBox(height: 5),
                  TextFormField(
                    controller: _accountNameController,
                    decoration: InputDecoration(
                      label: buildRequiredLabel(
                        AppLocalizations.of(context)!.accName,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: _accountNumberController,
                    decoration: InputDecoration(
                      label: buildRequiredLabel(
                        AppLocalizations.of(context)!.accNum,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      // only allow numbers
                      LengthLimitingTextInputFormatter(17),
                      // max 12 digits
                    ],
                    validator: (value) {
                      if ((value!.length < 11 || value.length > 12) &&
                          paymentMode == 'MFS') {
                        return AppLocalizations.of(context)!.accNumErr;
                      } else if ((value.length < 13 || value.length > 17) &&
                          paymentMode == 'Bank') {
                        return AppLocalizations.of(context)!.bankAccNumErr;
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 5),

                  if (paymentMode == 'MFS' &&
                      [1, 2, 4, 7].contains(selectedMfs?.id)) ...[
                    const SizedBox(height: 5),
                    ElevatedButton(
                      onPressed: () {
                        verifyMFS();
                      },
                      child: Text(AppLocalizations.of(context)!.verify),
                    ),
                  ],

                  const SizedBox(height: 15),
                  Text(
                    AppLocalizations.of(context)!.uploadCertificate,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 5),

                  buildImageUploadSection(
                    label: AppLocalizations.of(context)!.certEmp,
                    fileTypeId: 1,
                    file: employmentImage,
                    isUploading: isUploadingEmployment,
                  ),
                  buildImageUploadSection(
                    label: AppLocalizations.of(context)!.certUnemp,
                    fileTypeId: 2,
                    file: unemploymentImage,
                    isUploading: isUploadingUnemployment,
                  ),
                  buildImageUploadSection(
                    label: AppLocalizations.of(context)!.facePhoto,
                    fileTypeId: 3,
                    file: facePhotoImage,
                    isUploading: isUploadingFacePhoto,
                  ),
                  buildImageUploadSection(
                    label: AppLocalizations.of(context)!.nidCard,
                    fileTypeId: 4,
                    file: nidCardImage,
                    isUploading: isUploadingNidCard,
                  ),

                  const SizedBox(height: 5),

                  ElevatedButton(
                    onPressed: () {
                      final mfsNeedsVerification =
                          paymentMode == 'MFS' && mfsVerificationRequired;
                      if (_formKey.currentState!.validate()) {
                        if (mfsNeedsVerification && !isMfsVerified) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(context)!.pleaseVerifyMfs,
                              ),
                            ),
                          );
                          return;
                        }
                        _submitBankingDetails();
                      }
                    },
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
