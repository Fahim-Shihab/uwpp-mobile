import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:ubp/screens/landing_screen.dart';
import '../l10n/app_localizations.dart';
import '../utils/constants.dart';
import 'package:http_parser/http_parser.dart';

class UploadScreen extends StatefulWidget {
  final String nid;
  final String mobile;
  final String token;
  final String dob;

  const UploadScreen({required this.nid, required this.mobile, required this.token, required this.dob, super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? employmentImage;
  File? unemploymentImage;
  bool isUploadingEmployment = false;
  bool isUploadingUnemployment = false;
  bool isSubmitting = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(bool isEmployment) async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery); // Or use ImageSource.camera

    if (pickedFile != null) {
      setState(() {
        if (isEmployment) {
          employmentImage = File(pickedFile.path);
        } else {
          unemploymentImage = File(pickedFile.path);
        }
      });
    }
  }

  Future<void> submitFiles() async {
    if (employmentImage == null || unemploymentImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please upload both certificates')),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    final uri = Uri.parse("$actualBaseUrl/applicant/self-registration/upload-attachment");

    final token = widget.token;
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['nid'] = widget.nid // exactly like Postman (text field)
      ..files.add(await http.MultipartFile.fromPath(
        'employment',
        employmentImage!.path,
        filename: p.basename(employmentImage!.path),
        contentType: _getContentType(employmentImage!.path),
      ))
      ..files.add(await http.MultipartFile.fromPath(
        'unemployment',
        unemploymentImage!.path,
        filename: p.basename(unemploymentImage!.path),
        contentType: _getContentType(unemploymentImage!.path),
      ));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    setState(() {
      isSubmitting = false;
    });

    if (!mounted) return;
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.uploadSuccess)),
        );

        print(jsonDecode(response.body)["message"]);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => LandingScreen(mobile: widget.mobile, token: widget.token)),
              (route) => false,
        );
      } else {
        final errors = jsonDecode(response.body)["message"];
        final errorMessage = errors is List ? errors.join('\n') : errors.toString();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.uploadFail)),
      );
    }
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
    required bool isEmployment,
    required File? file,
    required bool isUploading,
  }) {
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
                  if (isEmployment) {
                    isUploadingEmployment = true;
                  } else {
                    isUploadingUnemployment = true;
                  }
                });

                await pickImage(isEmployment);

                setState(() {
                  if (isEmployment) {
                    isUploadingEmployment = false;
                  } else {
                    isUploadingUnemployment = false;
                  }
                });
              },
              child: Text(AppLocalizations.of(context)!.uploadImage),
            ),
            const SizedBox(width: 12),
            if (isUploading)
              SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
            else if (file != null)
              Expanded(
                child: Text(
                  p.basename(file.path),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.uploadCertificate)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              buildImageUploadSection(
                label: AppLocalizations.of(context)!.certEmp,
                isEmployment: true,
                file: employmentImage,
                isUploading: isUploadingEmployment,
              ),
              buildImageUploadSection(
                label: AppLocalizations.of(context)!.certUnemp,
                isEmployment: false,
                file: unemploymentImage,
                isUploading: isUploadingUnemployment,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: isSubmitting ? null : submitFiles,
                child: isSubmitting
                    ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text(AppLocalizations.of(context)!.submit),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
