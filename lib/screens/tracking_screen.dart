import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../l10n/app_localizations.dart';
import '../main.dart';
import '../models/grievanceHistory.dart';
import '../models/paymentHistory.dart';
import '../utils/constants.dart';
import '../utils/form_utils.dart';
import 'add_grievance_screen.dart';

class ApplicantDashboardScreen extends StatefulWidget {
  final String mobile;
  final String token;

  const ApplicantDashboardScreen({
    super.key, required this.mobile, required this.token
  });

  @override
  TrackingScreenState createState() => TrackingScreenState();
}

class TrackingScreenState extends State<ApplicantDashboardScreen> {
  @override
  void initState() {
    super.initState();
    initializeData();
  }

  final _nameEnController = TextEditingController();
  final _nameBnController = TextEditingController();
  final _fatherNameEnController = TextEditingController();
  final _fatherNameBnController = TextEditingController();
  final _factoryNameBnController = TextEditingController();
  final _factoryNameEnController = TextEditingController();
  final _applicationStatusNameEnController = TextEditingController();
  final _applicationStatusNameBnController = TextEditingController();
  List<PaymentHistory> paymentHistory = [];
  List<GrievanceHistory> grievanceHistory = [];

  Future<void> initializeData() async {
    final url = Uri.parse("$actualBaseUrl/applicant/profile/get?mobileNumber=" + widget.mobile);

    print("url: " + url.toString());

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        "Authorization": "Bearer ${widget.token}",
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("applicant profile");
      print(data);
      _nameBnController.text = data["nameBn"];
      _nameEnController.text = data["nameEn"];
      _fatherNameBnController.text = data["fatherNameBn"];
      _fatherNameEnController.text = data["fatherNameEn"];
      _factoryNameBnController.text = data["factoryNameBn"];
      _factoryNameEnController.text = data["factoryNameEn"];
      _applicationStatusNameEnController.text = data["statusEn"];
      _applicationStatusNameBnController.text = data["statusBn"];

      if (data['paymentHistory'] != null && data['paymentHistory'] != []) {
        print('payment history');
        print(data['paymentHistory']);
        List jsonList = data['paymentHistory'];
        setState(() {
          paymentHistory =
              jsonList.map((json) => PaymentHistory.fromJson(json)).toList();
        });
      }

      if (data['grievanceHistory'] != null && data['grievanceHistory'] != []) {
        print('grievance history');
        print(data['grievanceHistory']);
        List jsonList = data['grievanceHistory'];
        setState(() {
          grievanceHistory =
              jsonList.map((json) => GrievanceHistory.fromJson(json)).toList();
        });
      }
    } else {
      throw Exception('Failed to load applicant details');
    }
  }

  Widget _scrollableTable(Widget table) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: table,
    );
  }

  DataColumn tableHeader(String text, double width) {
    return DataColumn(
      label: SizedBox(
        width: width,
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  DataCell tableCell(String text, double width) {
    return DataCell(
      SizedBox(
        width: width,
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _paymentTable(List<PaymentHistory> data) {
    return _scrollableTable(
      DataTable(
        columns: [
          tableHeader(AppLocalizations.of(context)!.paymentCycle, 120),
          tableHeader(AppLocalizations.of(context)!.paymentAmount, 100),
          tableHeader(AppLocalizations.of(context)!.paymentStatus, 150),
        ],
        rows: data.map((e) {
          return DataRow(cells: [
            tableCell(e.paymentCycle, 120),
            tableCell(e.paymentAmount.toStringAsFixed(2), 100),
            tableCell(e.paymentStatus, 150),
          ]);
        }).toList(),
      ),
    );
  }

  Widget _buildPaymentCard(PaymentHistory p) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${AppLocalizations.of(context)!.paymentCycle}: ${p.paymentCycle}'),
          Text('${AppLocalizations.of(context)!.paymentAmount}: ${p.paymentAmount}'),
          Text('${AppLocalizations.of(context)!.paymentStatus}: ${p.paymentStatus}'),
        ],
      ),
    );
  }

  Widget _buildGrievanceCard(GrievanceHistory p) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${AppLocalizations.of(context)!.complainDate}: ${p.complainDate}'),
          Text('${AppLocalizations.of(context)!.trackingNumber}: ${p.trackingNumber}'),
          Text('${AppLocalizations.of(context)!.complainDetails}: ${p.complainDetails}'),
          Text('${AppLocalizations.of(context)!.grievanceType}: ${p.grievanceType}'),
          Text('${AppLocalizations.of(context)!.grievanceStatus}: ${p.grievanceStatus}'),
        ],
      ),
    );
  }

  Widget _grievanceTable(List<GrievanceHistory> data) {
    return _scrollableTable(
      DataTable(
        columns: [
          tableHeader(AppLocalizations.of(context)!.complainDate, 150),
          tableHeader(AppLocalizations.of(context)!.trackingNumber, 150),
          tableHeader(AppLocalizations.of(context)!.complainDetails, 150),
          tableHeader(AppLocalizations.of(context)!.grievanceType, 150),
          tableHeader(AppLocalizations.of(context)!.grievanceStatus, 150),
        ],
        rows: data.map((e) {
          return DataRow(cells: [
            tableCell(e.complainDate, 150),
            tableCell(e.trackingNumber, 150),
            tableCell(e.complainDetails, 150),
            tableCell(e.grievanceType, 150),
            tableCell(e.grievanceStatus, 150),
          ]);
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.applicantDashboard),
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _nameEnController,
                      readOnly: true,
                      decoration: InputDecoration(
                        label: buildRequiredLabel(
                          AppLocalizations.of(context)!.nameEn,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _nameBnController,
                      readOnly: true,
                      decoration: InputDecoration(
                        label: buildRequiredLabel(
                          AppLocalizations.of(context)!.nameBn,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _fatherNameEnController,
                      readOnly: true,
                      decoration: InputDecoration(
                        label: buildRequiredLabel(
                          AppLocalizations.of(context)!.fatherNameEn,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _fatherNameBnController,
                      readOnly: true,
                      decoration: InputDecoration(
                        label: buildRequiredLabel(
                          AppLocalizations.of(context)!.fatherNameBn,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _factoryNameBnController,
                      readOnly: true,
                      decoration: InputDecoration(
                        label: buildRequiredLabel(
                          "${AppLocalizations.of(context)!.factory} ${AppLocalizations.of(context)!.bangla}",
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _factoryNameEnController,
                      readOnly: true,
                      decoration: InputDecoration(
                        label: buildRequiredLabel(
                          "${AppLocalizations.of(context)!.factory} ${AppLocalizations.of(context)!.english}",
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _applicationStatusNameEnController,
                      readOnly: true,
                      decoration: InputDecoration(
                        label: buildRequiredLabel(
                            "${AppLocalizations.of(context)!.status} ${AppLocalizations.of(context)!.english}",
                      ),
                    ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _applicationStatusNameBnController,
                      readOnly: true,
                      decoration: InputDecoration(
                        label: buildRequiredLabel(
                          "${AppLocalizations.of(context)!.status} ${AppLocalizations.of(context)!.bangla}",
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(AppLocalizations.of(context)!.paymentInfo),
                    // _paymentTable(paymentHistory),
                    SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: paymentHistory.map((p) => SizedBox(
                        child: _buildPaymentCard(p),
                      )).toList(),
                    ),
                    SizedBox(height: 16),
                    Text(AppLocalizations.of(context)!.grievanceInfo),
                    SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: grievanceHistory.map((p) => SizedBox(
                        child: _buildGrievanceCard(p),
                      )).toList(),
                    ),
                    SizedBox(height: 16),
                    // _grievanceTable(grievanceHistory),
                    SizedBox(
                      width: double.infinity,
                      height: 70,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  AddGrievanceScreen(mobile: widget.mobile, token: widget.token),
                            ),
                          );
                        },
                        icon: const Icon(Icons.feedback, size: 28),
                        label: Text(
                          AppLocalizations.of(context)!.grievanceSubmission,
                          style: TextStyle(fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade100,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
